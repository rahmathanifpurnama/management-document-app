# Firebase Console Setup - Debug Token Configuration

## 🎯 **Quick Setup Guide**

Your debug token is: **`0D5038C4-B4F2-4628-8AD4-D500B904BA04`**

## 📋 **Step-by-Step Instructions**

### **Step 1: Access Firebase Console**
1. Open your web browser
2. Go to [Firebase Console](https://console.firebase.google.com/)
3. Sign in with your Google account
4. Select your project: **`document-management-c5a96`**

### **Step 2: Navigate to App Check**
1. In the left sidebar, click **"App Check"**
2. If you don't see App Check, look under **"Build"** section
3. You should see your Android app listed

### **Step 3: Configure Debug Token**
1. Find your Android app in the App Check dashboard
2. Click on your app (package name: `io.document.managementdoc`)
3. Look for **"Debug tokens"** section
4. Click **"Add debug token"** button

### **Step 4: Add Your Debug Token**
1. In the debug token field, enter: **`0D5038C4-B4F2-4628-8AD4-D500B904BA04`**
2. Optionally, add a description like: "Development Debug Token"
3. Click **"Save"** or **"Add"**

### **Step 5: Verify Configuration**
1. The debug token should now appear in your debug tokens list
2. Status should show as **"Active"**
3. You can edit or delete the token if needed

## 🔧 **Alternative: Copy from App**

If you prefer to copy the token from the app:

1. **Open the app** on your device/emulator
2. **Navigate to debug screen**:
   - **Option A**: Tap the red floating button on home screen (debug builds)
   - **Option B**: Profile → Settings → Firebase Debug
3. **Find the Debug Token section**
4. **Tap the copy button** next to the token
5. **Paste the token** in Firebase Console

## ✅ **Verification Steps**

After adding the debug token:

1. **Restart your app** completely
2. **Open the debug screen** in the app
3. **Run "Full Diagnostics"**
4. **Check App Check status** - should show "healthy" or "warning" instead of "error"
5. **Monitor logs** - should see fewer "placeholder token" warnings

## 🚨 **Troubleshooting**

### **If Debug Token is Rejected:**
- Ensure you copied the exact token: `0D5038C4-B4F2-4628-8AD4-D500B904BA04`
- Check that you selected the correct Android app
- Verify the package name matches: `io.document.managementdoc`

### **If App Check Still Shows Errors:**
- Wait 5-10 minutes for changes to propagate
- Restart the app completely
- Check internet connection
- Verify Firebase project is active

### **If You Can't Find App Check:**
- Ensure you have the correct permissions in Firebase Console
- App Check might be under "Build" section in newer Firebase Console versions
- Contact your Firebase project administrator

## 📱 **Expected Results**

After successful configuration:

### **Before (with errors):**
```
W/StorageUtil: Error getting App Check token; using placeholder token instead
W/NetworkRequest: no auth token for request
```

### **After (working correctly):**
```
✅ Firebase App Check: Token obtained
✅ Firebase Storage: Connected (X items found)
```

## 🔄 **Token Management**

### **Token Lifecycle:**
- Debug tokens are **permanent** until manually deleted
- They work across app reinstalls
- They're tied to your Firebase project, not the device

### **Security Notes:**
- Debug tokens are **only for development**
- **Never use debug tokens in production**
- Production apps use Play Integrity or Device Check

### **Multiple Developers:**
- Each developer can have their own debug token
- Or share the same token across the team
- Tokens can be managed centrally in Firebase Console

## 📞 **Need Help?**

If you encounter issues:

1. **Check the debug screen** in the app for detailed diagnostics
2. **Review the logs** for specific error messages
3. **Verify network connectivity** using the built-in network diagnostics
4. **Contact Firebase support** if console issues persist

---

**Remember**: This debug token (`0D5038C4-B4F2-4628-8AD4-D500B904BA04`) is pre-configured in your app and ready to use!
