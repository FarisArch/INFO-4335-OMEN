import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskHistory extends StatelessWidget {
  const TaskHistory({super.key});

  void _showTaskDetails(BuildContext context, var task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Task Details',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task ID:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${task['taskId']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Task Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${task['taskType']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${task['date']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${task['time']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${task['description']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Rate (Price):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('RM${task['price']}', style: TextStyle(fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Text(
                  'Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${task['status']}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: task['status'] == 'Completed' ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        'X',
                        style: TextStyle(fontSize: 50, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IIUM ERRAND RUNNER",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 8, 164, 92),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Task History',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('errands')
                    .where('status', isEqualTo: 'Completed') // Filter by status = 'Completed'
                    .orderBy('taskId') // Sort by taskId
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No completed tasks found.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  }

                  var taskHistory = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: taskHistory.length,
                    itemBuilder: (context, index) {
                      var task = taskHistory[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row to display taskId on the left and task type on the right
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Task ID: ${task['taskId']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      task['taskType'],  // Display task type here
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(task['date'], style: TextStyle(fontSize: 16, color: Colors.black54)),
                                    Text(task['time'], style: TextStyle(fontSize: 16, color: Colors.black54)),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  task['description'],
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Rate: RM${task['price']}",  // Display the rate (price)
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showTaskDetails(context, task); // Show the task details in popup
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 8, 196, 236),
                                      ),
                                      child: Text("Check Details", style: TextStyle(color: Colors.white)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: task['status'] == 'Completed' ? Colors.green[100] : Colors.red[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        task['status'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: task['status'] == 'Completed' ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/runner_dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Text("Back", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
