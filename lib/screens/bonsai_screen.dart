import 'package:flutter/material.dart';
import 'package:lucent/themes.dart';
import '../widgets/bonsai.dart';

class BonsaiScreen extends StatelessWidget {
  const BonsaiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock JSON from Supabase with visit timestamps
    const mockJson = '{"visits": ['
      '"2025-05-01T10:00:00Z",'
      '"2025-05-02T12:00:00Z",'
      '"2025-05-03T12:00:00Z",'
      '"2025-05-04T12:00:00Z",'
      '"2025-05-05T09:00:00Z",'
      '"2025-05-06T09:00:00Z",'
      '"2025-05-07T09:00:00Z",'
      '"2025-05-08T09:00:00Z",'
      '"2025-05-09T09:00:00Z",'
      '"2025-05-10T14:00:00Z",'
      '"2025-05-11T14:00:00Z",'
      '"2025-05-12T14:00:00Z",'
      '"2025-05-13T14:00:00Z",'
      '"2025-05-14T14:00:00Z",'
      '"2025-05-15T14:00:00Z",'
      '"2025-05-16T14:00:00Z",'
      '"2025-05-17T14:00:00Z",'
      '"2025-05-18T14:00:00Z",'
      '"2025-05-19T14:00:00Z",'
      '"2025-05-20T14:00:00Z",'
      '"2025-05-21T16:00:00Z",'
      '"2025-05-22T08:00:00Z",'
      '"2025-05-23T08:00:00Z",'
      '"2025-05-24T08:00:00Z",'
      '"2025-05-25T08:00:00Z",'
      '"2025-05-26T08:00:00Z",'
      '"2025-05-27T20:00:00Z",'
      '"2025-05-28T20:00:00Z",'
      '"2025-05-29T20:00:00Z",'
      '"2025-05-30T20:00:00Z",'
      '"2025-05-31T20:00:00Z"'
    ']}';

    return Scaffold(
      appBar: AppBar(title: const Text('Bonsai Calendar')),
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          color: AppColors.background,
          child: BonsaiTree.fromJson(
            mockJson,
          ),
        ),
      ),
    );
  }
}