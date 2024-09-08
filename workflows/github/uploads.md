# Different code snippets for uploading artifacts from a workflow to a specific server
## Using SCP
Env variables: `HOST`, `USERNAME`, `PASSWORD`

*ssh key could be used instead of plain password*
```yaml
      - name: Upload APK to server
        env:
          HOST: ${{ secrets.HOST }}
          USERNAME: ${{ secrets.USERNAME }}
          PASSWORD: ${{ secrets.PASSWORD }}
        run: |
          scp -o StrictHostKeyChecking=no app/build/outputs/apk/release/app-release.apk $USERNAME@$HOST:/var/www/html/latest.apk
```
## Using AWS S3 buckets
Env variables: `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `MINIO_ENDPOINT`

*example: http://minio.example.com:9000*
```yaml
      ### UBUNTU-LATEST ###
      - name: Install AWS CLI
        if: runner.os == 'Linux'
        run: |
          sudo apt-get update
          sudo apt-get install awscli

      ### MACOS-LATEST ###
      - name: Install AWS CLI
        if: runner.os == 'macOS'
        run: |
          brew install awscli
```
```yaml
      - name: Upload APK to Minio via AWS CLI
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.MINIO_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.MINIO_SECRET_KEY }}
          MINIO_BUCKET: BUCKET_NAME
          MINIO_ENDPOINT: ${{ secrets.MINIO_ENDPOINT }}
        run: |
          aws --endpoint-url $MINIO_ENDPOINT s3 cp android/app/build/outputs/apk/release/app-release.apk s3://$MINIO_BUCKET/app-release.apk
```
## Using Minio Client (mc)
Env variables: `MINIO_ENDPOINT`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `MINIO_REGION` (optional)

*example: http://minio.example.com:9000*
```yaml
      - name: Upload APK to Minio
        env:
          MINIO_ENDPOINT: ${{ secrets.MINIO_ENDPOINT }}
          MINIO_ACCESS_KEY: ${{ secrets.MINIO_ACCESS_KEY }}
          MINIO_SECRET_KEY: ${{ secrets.MINIO_SECRET_KEY }}
          MINIO_BUCKET: BUCKET_NAME
          MINIO_REGION: ${{ secrets.MINIO_REGION }} # OPTIONAL
        run: |
          # Install the Minio client (mc)
          wget https://dl.min.io/client/mc/release/linux-amd64/mc
          chmod +x mc
          ./mc alias set myminio $MINIO_ENDPOINT $MINIO_ACCESS_KEY $MINIO_SECRET_KEY --api S3v4
          
          # Upload the APK to Minio
          ./mc cp android/app/build/outputs/apk/release/app-release.apk myminio/$MINIO_BUCKET/app-release.apk
```