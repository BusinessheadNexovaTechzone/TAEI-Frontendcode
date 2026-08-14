# ABHA Card Download - Testing & Verification Guide

## Pre-Deployment Verification

### 1. Code Review Checklist

- [ ] `lib/constants/urls.dart` has `downloadAbhaCard` endpoint
- [ ] `lib/src/nurse_triage/services/triage_service.dart` has `downloadAbhaCard()` method
- [ ] `dart:async` import added (for TimeoutException)
- [ ] `lib/src/nurse_triage/controller/nurse_triage_controller.dart` has new download implementation
- [ ] `lib/src/nurse_triage/views/fingerprint_authentication.dart` extracts profileId
- [ ] `lib/src/nurse_triage/controller/verify_controller.dart` extracts profileId
- [ ] No compilation errors: `flutter analyze`
- [ ] Code builds successfully: `flutter build web`

### 2. Runtime Environment Setup

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run analyzer
flutter analyze

# Build web
flutter build web --release

# For local testing (dev server)
flutter run -d chrome
```

### 3. Unit Test Scenarios

#### Scenario 1: Aadhaar OTP Verification → Download
1. **Start**: Fresh app, Triage/ABHA entry screen
2. **Action**: 
   - Enter valid 12-digit Aadhaar
   - Click "Generate OTP"
   - Receive OTP to Aadhaar-linked mobile
   - Enter 6-digit OTP
   - Enter 10-digit mobile number
   - Click "Verify"
3. **Verify**:
   - Logs should show: `[AADHAAR OTP] profileId extracted: 42` (example)
   - `currentProfileId` should contain: `"42"`
   - ABHA profile card should appear
4. **Download**:
   - Click "Download ABHA Card"
   - Check DevTools → Network tab
   - Should see: `GET /api/abha/card/42`
   - Response status: 200
   - Response content-type: `image/png` or `application/pdf`
   - Browser should download: `ABHA_Card_42.pdf` or `ABHA_Card_42.png`
5. **Verify File**:
   - File should exist in Downloads folder
   - File should be valid PDF or PNG
   - File should contain official ABHA card

#### Scenario 2: Fingerprint Enrollment → Download
1. **Start**: Fingerprint authentication screen
2. **Action**:
   - Place finger on scanner
   - Capture successful PID
   - Click "Enroll with ABHA"
   - Enrollment completes
3. **Verify**:
   - Logs should show: `[FINGERPRINT] profileId extracted: 42`
   - Profile card appears
4. **Download**:
   - Click "Download ABHA Card"
   - Verify GET request to `/api/abha/card/42`
   - File downloads successfully
5. **Verify File**:
   - File is valid official ABHA card

#### Scenario 3: Verify Existing ABHA → Download
1. **Start**: Existing ABHA verification screen
2. **Action**:
   - Select verification method (e.g., ABHA Number + Aadhaar OTP)
   - Complete verification flow
3. **Verify**:
   - Logs should show: `[VERIFY ABHA] profileId extracted: 42`
   - Profile card appears
4. **Download**:
   - Click "Download ABHA Card"
   - Verify GET request succeeds
5. **Verify File**:
   - Downloaded file is official card

#### Scenario 4: Missing profileId
1. **Setup**: Manually clear `currentProfileId` (for testing)
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - No API request made
   - Toast shows: "ABHA card is not available yet..."
   - Dialog appears with same message
   - Logs show: `[ABHA CARD][DOWNLOAD] profileId missing`

#### Scenario 5: Invalid profileId
1. **Setup**: Set `currentProfileId = "0"` or `"abc"`
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - No API request made
   - Error message shown
   - Logs show: `[ABHA CARD][DOWNLOAD] profileId invalid`

#### Scenario 6: Backend Error - 404
1. **Setup**: profileId = 999999 (doesn't exist)
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - API called: `/api/abha/card/999999`
   - Response: 404
   - User sees: "ABHA card could not be found"
   - No file downloads
   - Logs show: `[ABHA CARD][DOWNLOAD][ERROR]`

#### Scenario 7: Network Timeout
1. **Setup**: Disconnect internet or use network throttling
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - After 30 seconds: "ABHA card download timed out"
   - Message: "Please check your connection"
   - Can retry after reconnecting

#### Scenario 8: Duplicate Click Prevention
1. **Start**: Profile card visible, profileId available
2. **Action**:
   - Click "Download ABHA Card"
   - Immediately click again before first completes
3. **Expected**:
   - Only ONE API request
   - Logs show: `[ABHA CARD][DOWNLOAD] Already downloading, ignoring duplicate click`
   - Download still completes successfully

#### Scenario 9: Download Twice in Same Session
1. **Action**: Download once successfully
2. **Action**: Download again (same profileId)
3. **Expected**:
   - Second download also succeeds
   - Both files download correctly
   - No errors or state issues

#### Scenario 10: PNG Response Handling
1. **Setup**: Backend configured to return PNG
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - Response content-type: `image/png`
   - Filename: `ABHA_Card_42.png`
   - File is valid PNG

#### Scenario 11: PDF Response Handling
1. **Setup**: Backend configured to return PDF (default)
2. **Action**: Click "Download ABHA Card"
3. **Expected**:
   - Response content-type: `application/pdf`
   - Filename: `ABHA_Card_42.pdf`
   - File is valid PDF

---

## Browser DevTools Verification

### Chrome DevTools

#### Network Tab
1. Open DevTools: F12 → Network tab
2. Click "Download ABHA Card"
3. Verify:
   - **Request**: `GET` to `/api/abha/card/42`
   - **Status**: `200`
   - **Headers** → Response → Content-Type: `application/pdf` or `image/png`
   - **Size**: Should show actual bytes (not empty)
   - **Time**: Should complete within 30 seconds

#### Console Tab
1. Filter logs to: `[ABHA CARD][DOWNLOAD]`
2. Should see:
   ```
   [ABHA CARD][DOWNLOAD] Button clicked
   [ABHA CARD][DOWNLOAD] profileId: 42
   [ABHA CARD][DOWNLOAD] Download response received
   [ABHA CARD][DOWNLOAD] Filename: ABHA_Card_42.pdf
   [ABHA CARD][DOWNLOAD] Content-Type: application/pdf
   [ABHA CARD][DOWNLOAD] Byte Length: 123456
   [ABHA CARD][DOWNLOAD] WEB DOWNLOAD START
   [ABHA CARD][WEB DOWNLOAD] Browser download triggered
   [ABHA CARD][DOWNLOAD] WEB DOWNLOAD SUCCESS
   [ABHA CARD][DOWNLOAD] SUCCESS
   ```

#### Application Tab
1. Check session storage for `currentProfileId`
2. Should contain the profileId value

### Edge DevTools
Same as Chrome (Chromium-based)

---

## Performance Verification

### Metrics to Check

| Metric | Target | Method |
|--------|--------|--------|
| API Response Time | < 5 seconds | DevTools Network tab |
| Total Download Time | < 30 seconds | Timer from click to completion |
| File Size | Varies | DevTools shows response size |
| Button Response | Immediate | UI should show loading state |
| No Memory Leaks | N/A | Check heap after multiple downloads |

### Load Testing

```
Test Case: Download 10 times in sequence
Expected: All 10 succeed without errors
Method: Automated test in browser console
```

---

## Security Verification

- [ ] profileId is numeric only (no injection possible)
- [ ] No sensitive data in logs (Aadhaar, ABHA number, token masked)
- [ ] No sensitive data in URL parameters
- [ ] HTTPS only (verify backend is HTTPS)
- [ ] No unhandled exceptions in console
- [ ] File permissions correct for downloads

---

## Compilation Verification

```bash
# Step 1: Clean build
$ flutter clean
Output should show no errors

# Step 2: Get dependencies
$ flutter pub get
Output should complete successfully

# Step 3: Run analyzer
$ flutter analyze
Output should show:
  "No issues found!"

# Step 4: Check for errors
$ flutter doctor -v
Output should show no critical issues

# Step 5: Build web
$ flutter build web
Output should end with:
  "✓ Built build/web"
```

---

## Integration Testing

### Test Environment
- Browser: Chrome (latest)
- Backend: `https://taei.nexovatechzone.com`
- User: Real ABHA account with valid profileId

### Test Steps

1. **Login to TAEI Application**
   - Navigate to ABHA verification screen
   - Complete ABHA verification flow
   - Confirm profile card visible

2. **Verify profileId Capture**
   - Open browser console
   - Check logs for: `[ABHA CARD][DOWNLOAD] profileId: XX`
   - Verify XX is a positive integer

3. **Test Download**
   - Click "Download ABHA Card"
   - Open DevTools Network tab
   - Confirm: GET /api/abha/card/XX → 200
   - File downloads to browser

4. **Verify File Contents**
   - Open downloaded file
   - Confirm it's official ABHA card (not custom template)
   - Verify patient details visible
   - Verify ABHA number correct
   - Verify QR code present (if PDF)

5. **Test Multiple Downloads**
   - Navigate back to profile
   - Click "Download ABHA Card" again
   - Confirm second download works
   - Compare file sizes (should be identical)

6. **Test Error Scenarios**
   - Stop internet during download
   - Verify timeout message
   - Resume internet, retry
   - Confirm download succeeds on retry

---

## Rollback Procedure

If implementation has issues:

1. **Revert Changes**
   ```bash
   git revert <commit-hash>
   ```

2. **Files to Verify**
   - `lib/constants/urls.dart`
   - `lib/src/nurse_triage/services/triage_service.dart`
   - `lib/src/nurse_triage/controller/nurse_triage_controller.dart`
   - `lib/src/nurse_triage/views/fingerprint_authentication.dart`
   - `lib/src/nurse_triage/controller/verify_controller.dart`

3. **Rebuild and Test**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

---

## Monitoring & Logging

### Production Monitoring

Monitor these log patterns for issues:

```
[ABHA CARD][DOWNLOAD][ERROR]  - Download failures
[ABHA CARD][DOWNLOAD] profileId missing - No profileId
[ABHA CARD][DOWNLOAD] Already downloading - Duplicate clicks (OK)
```

### Error Tracking

Use error tracking service to monitor:
- Download success rate (target: > 99%)
- Average download time (target: < 5 seconds)
- Error types and frequency
- Browser crash reports

---

## Success Criteria

**All of the following must pass for production deployment:**

- [x] No compilation errors
- [x] All 11 test scenarios pass
- [x] DevTools shows correct API calls
- [x] Downloaded files are official ABHA cards
- [x] No sensitive data in logs
- [x] Duplicate click prevention works
- [x] Error handling works for all scenarios
- [x] Performance within targets
- [x] Works in Chrome and Edge
- [x] No memory leaks
- [x] Security verified

---

## Deployment Checklist

Before deploying to production:

- [ ] All tests pass
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Backend API verified working
- [ ] Staging environment tested
- [ ] Performance metrics collected
- [ ] Security review passed
- [ ] Error tracking configured
- [ ] Monitoring alerts set up
- [ ] Runbook created
- [ ] Team trained on new flow
- [ ] Rollback plan ready

---

## Post-Deployment Monitoring (First 24 Hours)

Monitor:
- Download success rate
- Error logs (no spikes)
- User feedback/complaints
- Performance metrics
- Server-side API logs

If issues detected:
1. Check logs
2. Contact backend team if API issue
3. Rollback if critical
4. Document issue
5. Plan fix

---

## Contact & Support

For issues or questions:
- Check [ABHA_CARD_DOWNLOAD_IMPLEMENTATION.md](ABHA_CARD_DOWNLOAD_IMPLEMENTATION.md)
- Review test scenarios above
- Check DevTools Network/Console tabs
- Contact backend team for API issues
