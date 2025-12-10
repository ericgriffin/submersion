import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/units.dart';
import '../providers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Units'),
          _buildQuickUnitToggle(context, ref, settings),
          _buildUnitTile(
            context,
            title: 'Depth',
            value: settings.depthUnit.symbol,
            onTap: () => _showDepthUnitPicker(context, ref, settings.depthUnit),
          ),
          _buildUnitTile(
            context,
            title: 'Temperature',
            value: '°${settings.temperatureUnit.symbol}',
            onTap: () => _showTempUnitPicker(context, ref, settings.temperatureUnit),
          ),
          _buildUnitTile(
            context,
            title: 'Pressure',
            value: settings.pressureUnit.symbol,
            onTap: () => _showPressureUnitPicker(context, ref, settings.pressureUnit),
          ),
          const Divider(),

          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSelector(context, ref, settings.themeMode),
          const Divider(),

          _buildSectionHeader(context, 'Data'),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Import'),
            subtitle: const Text('Import dives from file'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export'),
            subtitle: const Text('Export all dives'),
            onTap: () {
              _showExportOptions(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup'),
            subtitle: const Text('Create a backup of your data'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup feature coming soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore'),
            subtitle: const Text('Restore from backup'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restore feature coming soon')),
              );
            },
          ),
          const Divider(),

          _buildSectionHeader(context, 'Dive Computer'),
          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: const Text('Connect Dive Computer'),
            subtitle: const Text('Import dives via Bluetooth'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dive computer connection coming soon')),
              );
            },
          ),
          const Divider(),

          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Submersion'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Submersion',
                applicationVersion: '0.1.0',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report an Issue'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visit github.com/submersion/submersion')),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildQuickUnitToggle(BuildContext context, WidgetRef ref, AppSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(
            value: true,
            label: Text('Metric'),
            icon: Icon(Icons.straighten),
          ),
          ButtonSegment(
            value: false,
            label: Text('Imperial'),
            icon: Icon(Icons.square_foot),
          ),
        ],
        selected: {settings.isMetric},
        onSelectionChanged: (selected) {
          final isMetric = selected.first;
          if (isMetric) {
            ref.read(settingsProvider.notifier).setMetric();
          } else {
            ref.read(settingsProvider.notifier).setImperial();
          }
        },
      ),
    );
  }

  Widget _buildUnitTile(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(_getThemeModeName(currentMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemePicker(context, ref, currentMode),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeModeName(mode)),
              secondary: Icon(_getThemeModeIcon(mode)),
              value: mode,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  void _showDepthUnitPicker(BuildContext context, WidgetRef ref, DepthUnit currentUnit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Depth Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DepthUnit.values.map((unit) {
            return RadioListTile<DepthUnit>(
              title: Text(unit == DepthUnit.meters ? 'Meters (m)' : 'Feet (ft)'),
              value: unit,
              groupValue: currentUnit,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setDepthUnit(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTempUnitPicker(BuildContext context, WidgetRef ref, TemperatureUnit currentUnit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Temperature Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TemperatureUnit.values.map((unit) {
            return RadioListTile<TemperatureUnit>(
              title: Text(unit == TemperatureUnit.celsius
                  ? 'Celsius (°C)'
                  : 'Fahrenheit (°F)'),
              value: unit,
              groupValue: currentUnit,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setTemperatureUnit(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPressureUnitPicker(BuildContext context, WidgetRef ref, PressureUnit currentUnit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pressure Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PressureUnit.values.map((unit) {
            return RadioListTile<PressureUnit>(
              title: Text(unit == PressureUnit.bar ? 'Bar' : 'PSI'),
              value: unit,
              groupValue: currentUnit,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setPressureUnit(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Export as UDDF'),
              subtitle: const Text('Universal Dive Data Format (XML)'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('UDDF export coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet format'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CSV export coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              subtitle: const Text('Printable logbook'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF export coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Submersion',
      applicationVersion: '0.1.0',
      applicationIcon: Icon(
        Icons.scuba_diving,
        size: 64,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: const [
        Text(
          'An open-source dive logging application.',
        ),
        SizedBox(height: 16),
        Text(
          'Track your dives, manage gear, and explore dive sites.',
        ),
      ],
    );
  }
}
