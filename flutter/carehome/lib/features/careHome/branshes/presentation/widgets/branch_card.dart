import 'package:flutter/material.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('assets/images/carehome.png'),
                  height: 100,
                  width: 100,
                ),

                const SizedBox(width: 10),

                Expanded(
                  // 🔑 مهم جدا علشان يمنع overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Sunrise Care Home",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 4),
                          Text("Ryadh - Saudi Arabia"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "dfhjkasdfhkjdsafkalsdfhdslfhdsfldshflsdahfhladsfdsfrterwtreterwt",
                        maxLines: 2, // 👈 سطرين فقط
                        overflow: TextOverflow.ellipsis, // 👈 ... لو زاد
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.delete, color: Colors.red),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("View Details"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.edit, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
