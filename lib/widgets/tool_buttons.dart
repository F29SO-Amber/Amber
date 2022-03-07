import 'package:flutter/material.dart';
import 'package:amber/pages/whiteboard_page/whiteboard_view_model.dart';

class ToolButtons extends StatelessWidget {
  final WhiteboardViewModel viewModel;

  const ToolButtons({Key? key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          color: viewModel.tool == Tool.pen ? Colors.black : Colors.black54,
          onPressed: () => viewModel.selectTool(Tool.pen),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          color: viewModel.tool == Tool.eraser ? Colors.black : Colors.black54,
          onPressed: () => viewModel.selectTool(Tool.eraser),
        ),
      ],
    );
  }
}
