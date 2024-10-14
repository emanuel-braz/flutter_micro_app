import 'package:devtools_app_shared/utils.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    FmaController().syncRemoteConfigData();

    // addAutoDisposeListener(FmaController().remoteConfig, () {
    //   setState(() {});
    // });
  }

  void _confirmChanges() {
    FmaController().syncRemoteConfigData(
        parameters: {'data': FmaController().value.remoteConfig});

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
                  IconButton(
                    icon: Icon(_isEditMode ? Icons.check : Icons.edit),
                    onPressed: () {
                      if (_isEditMode) {
                        _confirmChanges();
                      }
                      setState(() {
                        _isEditMode = !_isEditMode;
                      });
                    },
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
              body: PayloadModifierScreen(_isEditMode));
        });
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
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key, style: Theme.of(context).textTheme.displaySmall),
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
  }

  // Widget for text, int, double, list, map (TextField)
  Widget _buildTextField(String key, dynamic value, FmaState state) {
    TextEditingController controller =
        TextEditingController(text: value.toString());
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(key, style: Theme.of(context).textTheme.displaySmall)),
      subtitle: TextField(
        controller: controller,
        keyboardType: (value is int || value is double)
            ? TextInputType.number
            : TextInputType.text,
        enabled: widget.isEditMode,
        onChanged: widget.isEditMode
            ? (newValue) {
                if (value is int) {
                  state.remoteConfig[key] = int.tryParse(newValue) ?? value;
                } else if (value is double) {
                  state.remoteConfig[key] = double.tryParse(newValue) ?? value;
                } else {
                  state.remoteConfig[key] = newValue;
                }
              }
            : null,
        onSubmitted: widget.isEditMode
            ? (newValue) {
                setState(() {
                  if (value is int) {
                    state.remoteConfig[key] = int.tryParse(newValue) ?? value;
                  } else if (value is double) {
                    state.remoteConfig[key] =
                        double.tryParse(newValue) ?? value;
                  } else {
                    state.remoteConfig[key] = newValue;
                  }
                });
              }
            : null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
