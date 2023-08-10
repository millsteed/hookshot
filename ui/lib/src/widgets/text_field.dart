import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

enum TextFieldType { normal, name, email, password }

class TextField extends StatefulWidget {
  const TextField({
    super.key,
    this.type = TextFieldType.normal,
    required this.label,
    required this.onChanged,
  });

  const TextField.name({
    super.key,
    required this.label,
    required this.onChanged,
  }) : type = TextFieldType.name;

  const TextField.email({
    super.key,
    required this.label,
    required this.onChanged,
  }) : type = TextFieldType.email;

  const TextField.password({
    super.key,
    required this.label,
    required this.onChanged,
  }) : type = TextFieldType.password;

  final TextFieldType type;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  var _hasFocus = false;
  var _value = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() => setState(() => _hasFocus = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    return HoverableBuilder(
      mouseCursor: SystemMouseCursors.text,
      builder: (context, isHovered) => GestureDetector(
        onTap: _focusNode.requestFocus,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: _hasFocus
                  ? Colors.gray200
                  : isHovered
                      ? Colors.gray100
                      : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(Radius.medium),
            color: Colors.gray50,
          ),
          padding: const EdgeInsets.all(Spacing.small),
          child: Stack(
            children: [
              if (_value.isEmpty) ...[
                _buildPlaceholder(context),
              ],
              _buildEditableText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Text(
      widget.label,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.gray300,
      ),
    );
  }

  Widget _buildEditableText(BuildContext context) {
    return EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.black,
      ),
      cursorColor: Colors.black,
      backgroundCursorColor: Colors.black,
      selectionColor: Colors.gray200,
      textCapitalization: widget.type == TextFieldType.name
          ? TextCapitalization.words
          : TextCapitalization.none,
      keyboardType: widget.type == TextFieldType.email
          ? TextInputType.emailAddress
          : null,
      obscureText: widget.type == TextFieldType.password,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged(value);
      },
    );
  }
}
