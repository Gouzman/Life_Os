import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                'Bonjour Elie ??',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 6),

              Text(
                'Construisons une meilleure version de toi.',
              ),
            ],
          ),
        ),

        const CircleAvatar(
          radius: 24,
          child: Icon(Icons.person),
        ),
      ],
    );
  }
}
