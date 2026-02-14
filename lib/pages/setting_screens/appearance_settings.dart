import 'package:flutter/material.dart';
import 'package:task/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:task/widgets/icon_mapper.dart';
import 'package:task/widgets/setting_widgets/bottom_list_tile.dart';
import 'package:task/widgets/setting_widgets/top_list_tile.dart';

class AppearanceSettings extends StatelessWidget {
  // small palette for quick choosing
  static const List<Color> _palette = [
    Colors.blue,
    Colors.green,
    Colors.teal,
    Colors.purple,
    Color.fromRGBO(244, 67, 54, 1),
    Colors.deepOrange,
    Colors.pink,
    Colors.yellow,
  ];

  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final currentMode = themeProvider.themeMode;
    final seedColor = themeProvider.seedColor;
    final themeSource = themeProvider.themeSource;
    final isMono = themeProvider.isMonochrome;
    final isDynamic = themeProvider.isDynamic;

    final bool supportsDynamicColor =
        Theme.of(context).platform == TargetPlatform.android;

    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance"),
        centerTitle: true,
        animateColor: true,

        actions: [
          IconButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset theme?'),
                  content: const Text('This will restore theme defaults.'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  actions: [
                    FilledButton.tonal(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.error,
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await themeProvider.resetToDefaults();
              }
            },
            icon: Icon(remixIcon(Icons.restore)),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          physics: BouncingScrollPhysics(),
          children: [
            // --- Theme Mode (as smooth ChoiceChips) ---
            Card(
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Select theme mode.'),
                    const SizedBox(height: 12),

                    // Chips row
                    Builder(
                      builder: (context) {
                        // local helpers for label/icon
                        String labelFor(ThemeMode m) {
                          switch (m) {
                            case ThemeMode.system:
                              return 'System';
                            case ThemeMode.light:
                              return 'Light';
                            case ThemeMode.dark:
                              return 'Dark';
                          }
                        }

                        final chips = <Widget>[];
                        for (final mode in ThemeMode.values) {
                          chips.add(
                            Tooltip(
                              message: labelFor(mode),
                              child: ChoiceChip(
                                elevation: 0,
                                pressElevation: 0,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                // avatar: Icon(
                                //   remixIcon(iconFor(mode)),
                                //   size: 18,
                                // ),
                                label: Text(labelFor(mode)),
                                selected: currentMode == mode,
                                onSelected: (selected) {
                                  if (selected) {
                                    themeProvider.setThemeMode(mode);
                                    // ThemeProvider notifies; rebuild will reflect the new selection.
                                  }
                                },
                                selectedColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.12),
                                side: BorderSide(
                                  color: currentMode == mode
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    100,
                                  ),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                              ),
                            ),
                          );
                        }

                        return Wrap(spacing: 8, runSpacing: 8, children: chips);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- Seed color ---
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Accent color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeSource == ThemeSource.manual
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Text(
                      themeSource == ThemeSource.manual
                          ? 'Pick an accent color.'
                          : 'Selection is disabled in ${themeSource == ThemeSource.monochrome ? 'Monochrome' : 'Dynamic'} mode.',
                      style: TextStyle(
                        color: themeSource == ThemeSource.manual
                            ? null
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AbsorbPointer(
                      absorbing: themeSource != ThemeSource.manual,
                      child: Opacity(
                        opacity: themeSource == ThemeSource.manual ? 1.0 : 0.5,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _palette.map((c) {
                            final selected = c.value == seedColor.value;
                            return InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => themeProvider.setSeedColor(c),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      selected &&
                                          themeSource == ThemeSource.manual
                                      ? Border.all(
                                          width: 2,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        )
                                      : Border.all(
                                          width: 1,
                                          color: Colors.transparent,
                                        ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: c,
                                  radius: selected ? 20 : 19,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Wallpaper Scheme (Android only) ---
            if (supportsDynamicColor) ...[
              const SizedBox(height: 3),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
                elevation: 0,
                margin: EdgeInsets.zero,

                child: SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                  title: const Text('Dynamic color'),
                  subtitle: const Text('Use wallpaper colors.'),
                  value: isDynamic,
                  onChanged: (v) {
                    themeProvider.setThemeSource(
                      v ? ThemeSource.dynamic : ThemeSource.manual,
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 3),

            // --- Monochrome toggle ---
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: SwitchListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                title: const Text('Monochrome'),
                subtitle: const Text('Use monochrome palettes.'),
                value: isMono,
                onChanged: (v) {
                  themeProvider.setThemeSource(
                    v ? ThemeSource.monochrome : ThemeSource.manual,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Components',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,

                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 3),

            // --- Button Settings ---
            TopListTile(
              leading: Icon(remixIcon(Icons.height)),
              title: 'Buttons',
              subtitle: 'Adjust button height and radius.',

              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => const _ButtonSettingsDialog(),
                );
              },
            ),
            const SizedBox(height: 3),
            BottomListTile(
              leading: Icon(remixIcon(Icons.layers_outlined)),
              title: 'Cards',
              subtitle: 'Adjust corner radius.',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => const _CardSettingsDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSettingsDialog extends StatefulWidget {
  const _CardSettingsDialog();

  @override
  State<_CardSettingsDialog> createState() => _CardSettingsDialogState();
}

class _CardSettingsDialogState extends State<_CardSettingsDialog> {
  late double _currentRadius;
  final _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tp = Provider.of<ThemeProvider>(context, listen: false);
    _currentRadius = tp.cardRadius;
    _radiusController.text = _currentRadius.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _updateRadius(double val) {
    setState(() {
      _currentRadius = val.clamp(0.0, 100.0);
      _radiusController.text = _currentRadius.toStringAsFixed(1);
    });
    Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).setCardRadius(_currentRadius);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Card & List Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real-time preview card
            Center(
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Preview Card'),
                      const SizedBox(height: 8),
                      Text(
                        'This card shows the radius.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    // Radius section
                    Text(
                      'Corner Radius',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'Range: 0 - 100',
                      style: TextStyle(fontSize: 12),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _currentRadius,
                            min: 0.0,
                            max: 100.0,
                            onChanged: _updateRadius,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _radiusController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onSubmitted: (v) {
                              final val = double.tryParse(v);
                              if (val != null) {
                                _updateRadius(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ButtonSettingsDialog extends StatefulWidget {
  const _ButtonSettingsDialog();

  @override
  State<_ButtonSettingsDialog> createState() => _ButtonSettingsDialogState();
}

class _ButtonSettingsDialogState extends State<_ButtonSettingsDialog> {
  late double _currentHeight;
  late double _currentRadius;
  final _heightController = TextEditingController();
  final _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tp = Provider.of<ThemeProvider>(context, listen: false);
    _currentHeight = tp.buttonHeight;
    _currentRadius = tp.buttonRadius;
    _heightController.text = _currentHeight.toStringAsFixed(1);
    _radiusController.text = _currentRadius.toStringAsFixed(1);
  }

  @override
  void dispose() {
    _heightController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _updateHeight(double val) {
    setState(() {
      _currentHeight = val.clamp(30.0, 100.0);
      _heightController.text = _currentHeight.toStringAsFixed(1);
    });
    Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).setButtonHeight(_currentHeight);
  }

  void _updateRadius(double val) {
    setState(() {
      _currentRadius = val.clamp(0.0, 100.0);
      _radiusController.text = _currentRadius.toStringAsFixed(1);
    });
    Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).setButtonRadius(_currentRadius);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Button Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Real-time preview button
            Center(
              child: FilledButton(
                onPressed: () {},
                child: const Text('Preview Button'),
              ),
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    // Height section
                    Text(
                      'Height',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'Range: 30 - 100',
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _currentHeight,
                            min: 30.0,
                            max: 100.0,
                            onChanged: _updateHeight,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onSubmitted: (v) {
                              final val = double.tryParse(v);
                              if (val != null) {
                                _updateHeight(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    // Radius section
                    Text(
                      'Border Radius',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'Range: 0 - 100',
                      style: TextStyle(fontSize: 12),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _currentRadius,
                            min: 0.0,
                            max: 100.0,
                            onChanged: _updateRadius,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _radiusController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onSubmitted: (v) {
                              final val = double.tryParse(v);
                              if (val != null) {
                                _updateRadius(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
