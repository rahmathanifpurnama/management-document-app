# Firebase Deployment Guide

## Prerequisites
- Node.js installed (LTS version recommended)
- Firebase CLI installed globally
- Authenticated with Firebase account

## Quick Setup Commands

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Set Project
```bash
firebase use doc
# or
firebase use document-management-c5a96
```

## Deployment Commands

### Deploy Everything
```bash
firebase deploy
```

### Deploy Specific Services

#### Firestore Rules Only
```bash
firebase deploy --only firestore:rules
```

#### Storage Rules Only
```bash
firebase deploy --only storage
```

#### Cloud Functions Only
```bash
firebase deploy --only functions
```

#### Multiple Services
```bash
firebase deploy --only firestore:rules,storage,functions
```

## Development Commands

### Start Emulators
```bash
firebase emulators:start
```

### Start Specific Emulators
```bash
firebase emulators:start --only firestore,auth,storage
```

### Functions Development
```bash
cd functions
npm run serve
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Run as Administrator or use:
   npm install -g firebase-tools --unsafe-perm=true
   ```

2. **Login Issues**
   ```bash
   firebase logout
   firebase login --reauth
   ```

3. **Project Not Found**
   ```bash
   firebase projects:list
   firebase use --add
   ```

4. **Functions Build Errors**
   ```bash
   cd functions
   npm install
   npm run build
   ```

### Verify Installation
```bash
# Check versions
node --version
npm --version
firebase --version

# Check project status
firebase projects:list
firebase use

# Check current configuration
firebase list
```

## Project Structure
```
project/
├── firebase.json          # Firebase configuration
├── .firebaserc            # Project aliases
├── firestore.rules        # Firestore security rules
├── firestore.indexes.json # Firestore indexes
├── storage.rules          # Storage security rules
└── functions/             # Cloud Functions
    ├── package.json
    ├── tsconfig.json
    └── src/
        └── index.ts
```

## Environment Variables

For production deployment, ensure you have:
- Service account key (for admin operations)
- Proper environment variables set
- Correct project permissions

## Next Steps After Setup

1. Test emulators: `firebase emulators:start`
2. Deploy rules: `firebase deploy --only firestore:rules,storage`
3. Deploy functions: `firebase deploy --only functions`
4. Monitor logs: `firebase functions:log`
