import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/dependencies.dart';

import '../../controllers/fma_controller.dart';

class RemoteConfigPage extends StatefulWidget {
  const RemoteConfigPage({super.key});

  @override
  State<RemoteConfigPage> createState() => _RemoteConfigPageState();
}

class _RemoteConfigPageState extends State<RemoteConfigPage>
    with AutoDisposeMixin {
  bool _isEditMode = false;
  final _focusNode = FocusNode();
  bool _isMetaPressed = false;

  @override
  void initState() {
    super.initState();

    addAutoDisposeListener(FmaController().requestRemoteConfigKey, () {
      final key = FmaController().requestRemoteConfigKey.value;
      if (key != null) {
        FmaController().requestedKeys[key] =
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
      }
    });

    FmaController().syncRemoteConfigData();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _confirmChanges() {
    FmaController().syncRemoteConfigData(
        parameters: {'data': FmaController().value.remoteConfig});
    setState(() {
      _isEditMode = false;
    });
    l.d('Changes saved');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FmaController(),
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Remote Config'),
              centerTitle: true,
              actions: [
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_isEditMode) {
                          _confirmChanges();
                        } else {
                          setState(() {
                            _isEditMode = !_isEditMode;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _isEditMode ? 'Save' : 'Edit',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                          ),
                          const SizedBox(width: 8),
                          Icon(_isEditMode ? Icons.save : Icons.edit),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Switch(
                    value: value.enabled,
                    onChanged: (bool newValue) {
                      // value.enabled = newValue;
                      FmaController().syncRemoteConfigData(enabled: newValue);
                    },
                  ),
                ),
              ],
            ),
            body: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: _handleKeyEvent,
              child: PayloadModifierScreen(_isEditMode),
            ),
          );
        });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.metaLeft ||
          event.logicalKey == LogicalKeyboardKey.metaRight) {
        // Meta (Command) key is pressed
        _isMetaPressed = true;
      } else if (event.logicalKey == LogicalKeyboardKey.enter &&
          _isMetaPressed) {
        _isMetaPressed = false;
        // Enter key is pressed while Meta is active
        if (_isEditMode) {
          _confirmChanges();
        }
      }
    } else if (event is KeyUpEvent) {
      // Reset Meta key state when released
      if (event.logicalKey == LogicalKeyboardKey.metaLeft ||
          event.logicalKey == LogicalKeyboardKey.metaRight) {
        _isMetaPressed = false;
      }
    }
  }
}

class PayloadModifierScreen extends StatefulWidget {
  final bool isEditMode;
  const PayloadModifierScreen(this.isEditMode, {super.key});

  @override
  State createState() => _PayloadModifierScreenState();
}

class _PayloadModifierScreenState extends State<PayloadModifierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: FmaController(),
          builder: (context, value, child) {
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: value.remoteConfig.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = value.remoteConfig.entries.elementAt(index);
                return _buildItem(item.key, item.value, value);
              },
            );
          }),
    );
  }

  // Widget to build the corresponding input for each type
  Widget _buildItem(String key, dynamic value, FmaState state) {
    if (value is bool) {
      return _buildSwitchTile(key, value, state);
    } else {
      return _buildTextField(key, value, state);
    }
  }

  // Widget for boolean values (Switch)
  Widget _buildSwitchTile(String key, bool value, FmaState state) {
    return ValueListenableBuilder(
        valueListenable: FmaController().requestRemoteConfigKey,
        builder: (context, requestKey, child) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(key, style: Theme.of(context).textTheme.displaySmall),
                    if (FmaController().requestedKeys[key] != null)
                      CustomChip(
                          time: FmaController().requestedKeys[key] as String),
                  ],
                ),
                const SizedBox(height: 8),
                Switch(
                  value: value,
                  onChanged: widget.isEditMode
                      ? (newValue) {
                          setState(() {
                            state.remoteConfig[key] = newValue;
                          });
                        }
                      : null,
                ),
              ],
            ),
          );
        });
  }

  // Widget for text, int, double, list, map (TextField)
  Widget _buildTextField(String key, dynamic value, FmaState state) {
    TextEditingController controller =
        TextEditingController(text: value.toString());
    return Builder(builder: (context) {
      return ValueListenableBuilder(
          valueListenable: FmaController().requestRemoteConfigKey,
          builder: (context, requestKey, child) {
            return ListTile(
              title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(key,
                          style: Theme.of(context).textTheme.displaySmall),
                      if (FmaController().requestedKeys[key] != null)
                        CustomChip(
                            time: FmaController().requestedKeys[key] as String),
                    ],
                  )),
              subtitle: TextField(
                minLines: 1,
                maxLines: 50,
                controller: controller,
                keyboardType: (value is int || value is double)
                    ? TextInputType.number
                    : TextInputType.multiline,
                enabled: widget.isEditMode,
                onChanged: widget.isEditMode
                    ? (newValue) {
                        if (value is int) {
                          state.remoteConfig[key] =
                              int.tryParse(newValue) ?? value;
                        } else if (value is double) {
                          state.remoteConfig[key] =
                              double.tryParse(newValue) ?? value;
                        } else {
                          state.remoteConfig[key] = newValue;
                        }
                      }
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            );
          });
    });
  }
}

class CustomChip extends StatelessWidget {
  final String time;
  const CustomChip({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).buttonTheme.colorScheme!.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Fetched',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            if (time.isNotEmpty)
              Text(
                time,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    height: 1.2,
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
          ],
        ),
      ),
    );
  }
}
