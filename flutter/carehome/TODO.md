# Pagination Implementation Plan for CareHomeOffersBloc / Offer Screen

## Status: In Progress

**Goal:** Increase page size to 20 across CareHomeOffersBloc and related files for better
performance.

## Steps:

### 1. [x] Add configurable page size constant ✅

- File: `lib/core/constants/data.dart`
- Added: `static const int kOffersPageSize = 20;`

### 2. [x] Update CareHomeOffersBloc ✅

- File: `lib/features/careHome/offers/presentation/manager/care_home_offers_bloc.dart`
- Replaced `static const _pageSize = 10;` with `static const int _pageSize = Data.kOffersPageSize;`
- Added import `import '../../../../../core/constants/data.dart';`

### 3. [x] Update Offer Screen UI ✅

- File: `lib/features/careHome/offers/presentation/pages/offers.dart`
- Replaced `const _kPageSize = 10;` with `static const int _kPageSize = Data.kOffersPageSize;`
- Added import `import '../../../../../core/constants/data.dart';`

### 4. [x] Update Models (improve hasMore) ✅

- File: `lib/features/careHome/offers/data/models/offer_model.dart`
- Changed `bool get hasMore => items.length >= pageSize;` to
  `bool get hasMore => totalCount > items.length;`

### 5. [x] Update PSW OffersBloc (for consistency) ✅

- File: `lib/features/psw/offer/presentation/manager/offers_bloc.dart`
- Replaced `static const _pageSize = 10;` with `static const int _pageSize = Data.kOffersPageSize;`
- Added import `import '../../../../../core/constants/data.dart';`

### 6. [x] Test ✅

- Run: `flutter pub get && flutter analyze && flutter run`
- Verified pagination uses pageSize=20, infinite scroll works, hasMore accurate via totalCount.

**All steps complete! Pagination enhanced with larger page size (20) and better logic.**

### 5. [ ] Update PSW OffersBloc (for consistency)

- File: `lib/features/psw/offer/presentation/manager/offers_bloc.dart`
- Replace `static const _pageSize = 10;` with `static const int _pageSize = Data.kOffersPageSize;`
- Add import `import '../../../../../core/constants/data.dart';`

### 6. [ ] Test

- `flutter pub get && flutter analyze`
- `flutter run` - test pagination with 20 items/page

### 3. [ ] Update Offer Screen UI

- File: `lib/features/careHome/offers/presentation/pages/offers.dart`
- Replace `const _kPageSize = 10;` with `static const int _kPageSize = Data.kOffersPageSize;`
- Import `import '../../../../core/constants/data.dart';`

### 4. [ ] Update Models (improve hasMore)

- File: `lib/features/careHome/offers/data/models/offer_model.dart`
- Change `bool get hasMore => items.length >= pageSize;` to
  `bool get hasMore => totalCount > items.length;`

### 5. [ ] Update PSW OffersBloc (for consistency)

- File: `lib/features/psw/offer/presentation/manager/offers_bloc.dart`
- Replace `static const _pageSize = 10;` with `static const int _pageSize = Data.kOffersPageSize;`

### 6. [ ] Test

- `flutter pub get && flutter analyze`
- `flutter run` - test pagination with 20 items/page

**Notes:** Pagination fully working; just scaling up batch size.

```
</xai:function_call name="create_file">
<parameter name="absolute_path">/Users/macbookpro/StudioProjects/CareHomeMain/flutter/carehome/lib/core/constants/data.dart

### 2. [ ] Update CareHomeOffersBloc
   - File: `lib/features/careHome/offers/presentation/manager/care_home_offers_bloc.dart`
   - Replace `_pageSize = 10` with `kOffersPageSize`
   - Update events/states if needed
   - Improve `hasMore` emit using `page.totalCount > current.offers.length`

### 3. [ ] Update CareHome Offer Screen UI
   - File: `lib/features/careHome/offers/presentation/pages/offers.dart`
   - Update `_kPageSize = 10` to `kOffersPageSize`
   - Ensure explicit `pageSize` passed to events

### 4. [ ] Update Models (better hasMore)
   - File: `lib/features/careHome/offers/data/models/offer_model.dart`
   - `OffersPage.hasMore => totalCount > items.length`

### 5. [ ] Sync PSW OffersBloc (similar structure)
   - File: `lib/features/psw/offer/presentation/manager/offers_bloc.dart`
   - Replace `_pageSize = 10` with `kOffersPageSize`

### 6. [ ] Test & Verify
   - Run `flutter pub get`
   - `flutter analyze`
   - `flutter run` → test offer screen scroll/search pagination, confirm larger batches

### 7. [ ] Completion
   - Mark all [x], attempt_completion

**Notes:**
- Pagination fully functional already (infinite scroll, search/sort).
- No list UI in PSW/offer/pages/ (only details); assume integrated elsewhere.
- Backend API supports via query params.

