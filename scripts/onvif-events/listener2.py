#!/usr/bin/env python3
"""
TP-Link Tapo Camera ONVIF Event Listener

This script connects to a TP-Link Tapo camera and listens to all ONVIF events
including motion detection, line crossing, field detection, etc.

Dependencies:
    pip install onvif-zeep requests lxml

Usage:
    python tapo_onvif_listener.py
"""

import asyncio
import time
import logging
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
import xml.etree.ElementTree as ET
import os

try:
    from onvif import ONVIFCamera
except ImportError:
    print("Required dependencies not found. Please install:")
    print("pip install onvif-zeep requests lxml")
    exit(1)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class TapoONVIFEventListener:
    def __init__(self, host: str, port: int = 2020, username: str = "admin", password: str = ""):
        """
        Initialize the Tapo ONVIF Event Listener
        
        Args:
            host: Camera IP address
            port: ONVIF port (default 2020 for Tapo cameras)
            username: Camera username (usually 'admin')
            password: Camera password
        """
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.camera: Optional[ONVIFCamera] = None
        self.event_service = None
        self.pullpoint = None
        self.subscription_reference = None
        
    def connect(self) -> bool:
        """Connect to the camera and initialize services"""
        try:
            logger.info(f"Connecting to camera at {self.host}:{self.port}")
            
            # Create ONVIF camera instance
            self.camera = ONVIFCamera(
                self.host, 
                self.port, 
                self.username, 
                self.password,
                # wsdl_dir='./wsdl/'  # You may need to adjust this path
            )
            
            # Get event service
            self.event_service = self.camera.create_events_service()
            
            # Test connection
            device_info = self.camera.devicemgmt.GetDeviceInformation()
            logger.info(f"Connected to: {device_info.Manufacturer} {device_info.Model}")
            logger.info(f"Firmware: {device_info.FirmwareVersion}")
            
            return True
            
        except Exception as e:
            logger.error(f"Failed to connect to camera: {e}")
            return False
    
    def get_event_properties(self) -> Dict[str, Any]:
        """Get available event properties from the camera"""
        try:
            capabilities = self.event_service.GetEventProperties()
            logger.info("Available event properties:")
            
            # Parse and display event topics
            if hasattr(capabilities, 'TopicSet'):
                topics = self._parse_topics(capabilities.TopicSet)
                for topic in topics:
                    logger.info(f"  - {topic}")
            
            return capabilities
            
        except Exception as e:
            logger.error(f"Failed to get event properties: {e}")
            return {}
    
    def _parse_topics(self, topic_set) -> list:
        """Parse topic set to extract event topics"""
        topics = []
        try:
            # Convert to string and parse XML if needed
            if hasattr(topic_set, '_value_1'):
                topic_xml = str(topic_set._value_1)
                root = ET.fromstring(f"<root>{topic_xml}</root>")
                
                # Extract topic paths
                for elem in root.iter():
                    if elem.tag and not elem.tag.startswith('ns'):
                        topics.append(elem.tag)
            
        except Exception as e:
            logger.warning(f"Could not parse topics: {e}")
            topics = ["Motion", "LineDetector", "FieldDetector", "CellMotionDetector"]
            
        return topics
    
    def create_pullpoint_subscription(self) -> bool:
        """Create a pull-point subscription for events"""
        try:
            logger.info("Creating pull-point subscription...")
            
            # Create pull point subscription
            response = self.event_service.CreatePullPointSubscription()
            
            if hasattr(response, 'SubscriptionReference'):
                self.subscription_reference = response.SubscriptionReference
                logger.info("Pull-point subscription created successfully")
                
                # Get the pull point service
                pullpoint_service = self.camera.create_pullpoint_service(
                    response.SubscriptionReference.Address._value_1
                )
                self.pullpoint = pullpoint_service
                
                return True
            else:
                logger.error("Failed to create subscription - no reference returned")
                return False
                
        except Exception as e:
            logger.error(f"Failed to create pull-point subscription: {e}")
            return False
    
    def start_listening(self, timeout: int = 60):
        """Start listening for events"""
        if not self.pullpoint:
            logger.error("No pull-point subscription available")
            return
            
        logger.info("Starting event listener...")
        logger.info("Listening for events (Press Ctrl+C to stop)...")
        
        try:
            while True:
                try:
                    # Pull messages from the subscription
                    response = self.pullpoint.PullMessages({
                        'Timeout': f'PT{timeout}S',  # Timeout in seconds
                        'MessageLimit': 10
                    })
                    
                    if hasattr(response, 'NotificationMessage'):
                        messages = response.NotificationMessage
                        if not isinstance(messages, list):
                            messages = [messages]
                            
                        for message in messages:
                            self._process_event(message)
                    else:
                        logger.debug("No events received")
                        
                    time.sleep(1)  # Small delay between pulls
                    
                except KeyboardInterrupt:
                    logger.info("Stopping event listener...")
                    break
                except Exception as e:
                    logger.error(f"Error pulling messages: {e}")
                    time.sleep(5)  # Wait before retrying
                    
        finally:
            self._cleanup()
    
    def _process_event(self, message):
        """Process received event message"""
        try:
            timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            
            # Extract basic information
            topic = getattr(message.Topic, '_value_1', 'Unknown') if hasattr(message, 'Topic') else 'Unknown'
            
            logger.info(f"[{timestamp}] EVENT RECEIVED")
            logger.info(f"  Topic: {topic}")
            
            # Extract message data
            if hasattr(message, 'Message'):
                msg_data = message.Message
                
                # Try to extract common event data
                if hasattr(msg_data, 'Data'):
                    data = msg_data.Data
                    
                    # Motion detection
                    if hasattr(data, 'SimpleItem'):
                        items = data.SimpleItem if isinstance(data.SimpleItem, list) else [data.SimpleItem]
                        for item in items:
                            name = getattr(item, 'Name', 'Unknown')
                            value = getattr(item, 'Value', 'Unknown')
                            logger.info(f"    {name}: {value}")
                    
                    # Source information
                    if hasattr(msg_data, 'Source'):
                        source = msg_data.Source
                        if hasattr(source, 'SimpleItem'):
                            source_items = source.SimpleItem if isinstance(source.SimpleItem, list) else [source.SimpleItem]
                            for item in source_items:
                                name = getattr(item, 'Name', 'Unknown')
                                value = getattr(item, 'Value', 'Unknown')
                                logger.info(f"  Source {name}: {value}")
            
            # UTC time from camera
            if hasattr(message, 'UtcTime'):
                camera_time = message.UtcTime
                logger.info(f"  Camera Time: {camera_time}")
            
            logger.info("-" * 50)
            
        except Exception as e:
            logger.error(f"Error processing event: {e}")
            logger.debug(f"Raw message: {message}")
    
    def _cleanup(self):
        """Clean up subscription and connection"""
        try:
            if self.pullpoint and self.subscription_reference:
                logger.info("Unsubscribing from events...")
                self.pullpoint.Unsubscribe()
                
        except Exception as e:
            logger.error(f"Error during cleanup: {e}")

def main():
    """Main function"""
    # Camera configuration - UPDATE THESE VALUES
    CAMERA_IP = "192.168.50.84"  # Replace with your camera's IP
    CAMERA_PORT = 2020           # Default ONVIF port for Tapo cameras
    USERNAME = os.environ['ONVIF_USERNAME']
    PASSWORD = os.environ['ONVIF_PASS']
    
    # Create event listener
    listener = TapoONVIFEventListener(
        host=CAMERA_IP,
        port=CAMERA_PORT,
        username=USERNAME,
        password=PASSWORD
    )
    
    # Connect to camera
    if not listener.connect():
        logger.error("Failed to connect to camera. Exiting.")
        return
    
    # Get available event properties
    listener.get_event_properties()
    
    # Create subscription
    if not listener.create_pullpoint_subscription():
        logger.error("Failed to create event subscription. Exiting.")
        return
    
    # Start listening for events
    listener.start_listening()

if __name__ == "__main__":
    main()