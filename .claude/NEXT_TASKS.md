# Immediate Development Tasks

## Task 1: Connect Dive Sites UI to Data Layer

**Files to modify:**
- `lib/features/dive_sites/presentation/pages/site_list_page.dart`

**Steps:**
1. Convert `SiteListPage` from `StatelessWidget` to `ConsumerWidget`
2. Watch `sitesWithCountsProvider` from `site_providers.dart`
3. Use `.when()` pattern to handle loading/error/data states
4. Display sites using existing `SiteListTile` widget
5. Wire up FAB to navigate to site creation

**Pattern to follow (from dive_list_page.dart):**
```dart
class SiteListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(sitesWithCountsProvider);
    return Scaffold(
      body: sitesAsync.when(
        data: (sites) => sites.isEmpty ? _buildEmptyState(context) : _buildSiteList(context, ref, sites),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

---

## Task 2: Create Site Edit Page

**Files to create:**
- `lib/features/dive_sites/presentation/pages/site_edit_page.dart`

**Form fields needed:**
- Name (required)
- Description
- Country
- Region
- Max Depth
- Rating (1-5 stars)
- Latitude/Longitude (optional GPS)
- Notes

**Provider to use:** `siteListNotifierProvider` for `.addSite()` and `.updateSite()`

---

## Task 3: Connect Gear UI to Data Layer

**Files to modify:**
- `lib/features/gear/presentation/pages/gear_list_page.dart`

**Steps:**
1. Convert to `ConsumerStatefulWidget` (needs TabController)
2. Watch `gearListNotifierProvider` for active gear tab
3. Watch `retiredGearProvider` for retired gear tab
4. Update `_AddGearSheetState` to use `ref.read(gearListNotifierProvider.notifier).addGear()`

**Entity to create for form:**
```dart
final gear = GearItem(
  id: '',
  name: _nameController.text,
  type: _selectedType,
  brand: _brandController.text.isEmpty ? null : _brandController.text,
  model: _modelController.text.isEmpty ? null : _modelController.text,
  serialNumber: _serialController.text.isEmpty ? null : _serialController.text,
  purchaseDate: null,
  isRetired: false,
);
```

---

## Task 4: Add Site Picker to Dive Edit

**File to modify:**
- `lib/features/dive_log/presentation/pages/dive_edit_page.dart`

**Implementation:**
1. Add `siteId` state variable
2. Create site dropdown/search field
3. Watch `sitesProvider` for site list
4. Update `_saveDive()` to include selected site

**UI options:**
- Simple: `DropdownButtonFormField<String>` with site names
- Better: Custom search field with `showSearch()` delegate

---

## Task 5: Implement Search in Dive List

**File to modify:**
- `lib/features/dive_log/presentation/pages/dive_list_page.dart`

**Implementation:**
1. Add `SearchDelegate` class for dive search
2. Use `diveSearchProvider.family` with query parameter
3. Wire up search icon in AppBar to `showSearch()`

---

## Helpful Code Snippets

### Converting StatelessWidget to ConsumerWidget
```dart
// Before
class MyPage extends StatelessWidget {
  Widget build(BuildContext context) { ... }
}

// After
class MyPage extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myProvider);
    ...
  }
}
```

### Accessing notifier for mutations
```dart
// Read (for one-time actions like save)
ref.read(siteListNotifierProvider.notifier).addSite(site);

// Watch (for reactive UI updates)
final sitesAsync = ref.watch(sitesWithCountsProvider);
```

### Import alias for domain entities
```dart
import '../../domain/entities/dive_site.dart' as domain;
// Then use: domain.DiveSite, domain.GeoPoint
```
