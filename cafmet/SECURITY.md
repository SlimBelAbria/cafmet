# Security Configuration Guide

## ⚠️ IMPORTANT: Before Running This Application

This application requires several sensitive configuration values that should **NEVER** be committed to version control. Follow these steps to configure the application securely.

## Required Environment Variables

### 1. Google Service Account Credentials
The application uses Google Sheets API and requires a service account. You need to:

1. Create a Google Cloud Project
2. Enable Google Sheets API
3. Create a Service Account
4. Download the JSON credentials file
5. Set the environment variable:

```bash
# For development
export GOOGLE_SERVICE_ACCOUNT_CREDENTIALS='{"type":"service_account",...}'

# For Flutter builds
flutter build apk --dart-define=GOOGLE_SERVICE_ACCOUNT_CREDENTIALS='{"type":"service_account",...}'
```

### 2. Google Maps API Key
You need a Google Maps API key for map functionality:

```bash
# For Android builds
flutter build apk --dart-define=MAPS_API_KEY=YOUR_API_KEY_HERE
```

### 3. Support Email
Configure the support email address:

```bash
flutter build apk --dart-define=SUPPORT_EMAIL=support@yourdomain.com
```

## Security Best Practices

1. **Never commit credentials to version control**
2. **Use environment variables for all sensitive data**
3. **Restrict API keys to specific domains/IPs**
4. **Regularly rotate API keys and credentials**
5. **Use service accounts with minimal required permissions**

## Build Configuration

For production builds, use:

```bash
flutter build apk \
  --dart-define=GOOGLE_SERVICE_ACCOUNT_CREDENTIALS='YOUR_CREDENTIALS_JSON' \
  --dart-define=MAPS_API_KEY=YOUR_MAPS_API_KEY \
  --dart-define=SUPPORT_EMAIL=support@yourdomain.com
```

## Troubleshooting

If you see errors about missing credentials:
1. Check that all environment variables are set
2. Verify the Google Service Account has proper permissions
3. Ensure the Google Sheets are shared with the service account email
4. Check that API keys are valid and not restricted

## Emergency Actions

If credentials have been exposed:
1. **IMMEDIATELY** revoke the exposed credentials in Google Cloud Console
2. Generate new service account credentials
3. Update all environment variables
4. Review access logs for unauthorized usage 