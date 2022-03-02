import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amber/pages/whiteboard_page/whiteboard_view_model.dart';
import 'package:amber/widgets/tool_buttons.dart';
import 'package:amber/widgets/whiteboard_view.dart';

class WhiteboardPage extends StatelessWidget {
  const WhiteboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WhiteboardViewModel>(
      builder: (context, viewModel, _) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Stack(
                children: <Widget>[
                  WhiteboardView(
                    lines: viewModel.lines,
                    onGestureStart: viewModel.onGestureStart,
                    onGestureUpdate: viewModel.onGestureUpdate,
                    onGestureEnd: viewModel.onGestureEnd,
                  ),
                  ToolButtons(viewmodel: viewModel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteboardPageRoute extends MaterialPageRoute<void> {
  static const id = 'wpageroute';
  WhiteboardPageRoute(String id)
      : super(
          builder: (context) => ChangeNotifierProvider<WhiteboardViewModel>(
            create: (context) {
              final firestore = Provider.of<FirebaseFirestore>(context, listen: false);
              return WhiteboardViewModel(firestore, id);
            },
            child: WhiteboardPage(),
          ),
        );
}
