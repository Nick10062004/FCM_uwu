import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivorn FCM DB Explorer (Web)',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const WebDatabaseExplorer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebDatabaseExplorer extends StatefulWidget {
  const WebDatabaseExplorer({super.key});

  @override
  State<WebDatabaseExplorer> createState() => _WebDatabaseExplorerState();
}

class _WebDatabaseExplorerState extends State<WebDatabaseExplorer> {
  // Use http://localhost:3000/api/dev as our DB Bridge
  final String _baseUrl = 'http://localhost:3000/api/dev';

  List<String> _tables = [];
  String? _selectedTable;
  List<Map<String, dynamic>> _columns = [];
  List<Map<dynamic, dynamic>> _rows = [];
  String _status = "Ready";

  @override
  void initState() {
    super.initState();
    _connectToDb();
  }

  Future<void> _connectToDb() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tables'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tables = List<String>.from(data['data']);
          _status = "Connected to Backend DB Bridge.";
          _selectedTable = null;
          _rows = [];
          _columns = [];
        });
      } else {
        setState(() => _status = "Error: Backend unreachable.");
      }
    } catch (e) {
      setState(() => _status = "Connection Error: $e");
    }
  }

  Future<void> _selectTable(String tableName) async {
    try {
      // 1. Identify Columns using Bridge SQL
      final colInfoRes = await http.post(
        Uri.parse('$_baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sql': "PRAGMA table_info('$tableName');"}),
      );

      final colData = json.decode(colInfoRes.body)['data'];
      final List<Map<String, dynamic>> cols = (colData as List)
          .map(
            (row) => {
              'name': row['name'],
              'type': row['type'],
              'pk': row['pk'] != 0,
            },
          )
          .toList();

      // 2. Fetch Data using Bridge SQL
      final dataRes = await http.post(
        Uri.parse('$_baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'sql': "SELECT * FROM [$tableName];"}),
      );

      final rowData = json.decode(dataRes.body)['data'];
      final List<Map<dynamic, dynamic>> rows = List<Map<dynamic, dynamic>>.from(
        rowData,
      );

      setState(() {
        _selectedTable = tableName;
        _columns = cols;
        _rows = rows;
        _status = "Table: $tableName (${rows.length} rows)";
      });
    } catch (e) {
      setState(() => _status = "Query Error: $e");
    }
  }

  Future<void> _deleteRow(Map<dynamic, dynamic> rowData) async {
    if (_selectedTable == null) return;

    final pkCol = _columns.firstWhere(
      (c) => c['pk'],
      orElse: () => _columns.first,
    );
    final pkName = pkCol['name'];
    final pkValue = rowData[pkName];

    try {
      await http.post(
        Uri.parse('$_baseUrl/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sql': "DELETE FROM [$_selectedTable] WHERE [$pkName] = ?;",
          'params': [pkValue],
        }),
      );
      _selectTable(_selectedTable!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Row deleted")));
    } catch (e) {
      _showErrorDialog("Delete Error", e.toString());
    }
  }

  void _showEditDialog(Map<dynamic, dynamic>? rowData) {
    if (_selectedTable == null) return;

    final Map<String, TextEditingController> controllers = {};
    for (var col in _columns) {
      controllers[col['name']] = TextEditingController(
        text: rowData != null ? rowData[col['name']]?.toString() ?? "" : "",
      );
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          rowData == null ? "Add New Row to $_selectedTable" : "Edit Row",
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _columns.map((col) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: controllers[col['name']],
                  decoration: InputDecoration(
                    labelText: "${col['name']} (${col['type']})",
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveRow(rowData, controllers);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRow(
    Map<dynamic, dynamic>? originalRow,
    Map<String, TextEditingController> controllers,
  ) async {
    if (_selectedTable == null) return;

    try {
      final names = controllers.keys.toList();
      final values = names.map((k) => controllers[k]!.text).toList();

      if (originalRow == null) {
        final placeHolders = List.filled(names.length, "?").join(", ");
        await http.post(
          Uri.parse('$_baseUrl/query'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'sql':
                "INSERT INTO [$_selectedTable] (${names.map((n) => "[$n]").join(", ")}) VALUES ($placeHolders);",
            'params': values,
          }),
        );
      } else {
        final pkCol = _columns.firstWhere(
          (c) => c['pk'],
          orElse: () => _columns.first,
        );
        final pkName = pkCol['name'];
        final pkValue = originalRow[pkName];

        final setClause = names.map((n) => "[$n] = ?").join(", ");
        await http.post(
          Uri.parse('$_baseUrl/query'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'sql':
                "UPDATE [$_selectedTable] SET $setClause WHERE [$pkName] = ?;",
            'params': [...values, pkValue],
          }),
        );
      }
      _selectTable(_selectedTable!);
    } catch (e) {
      _showErrorDialog("Save Error", e.toString());
    }
  }

  void _showErrorDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vivorn FCM: Local DB Explorer (via Chrome Hub)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _connectToDb,
            tooltip: "Refresh Tables",
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar: List Tables
          Container(
            width: 250,
            color: Colors.black26,
            child: ListView.builder(
              itemCount: _tables.length,
              itemBuilder: (context, index) {
                final t = _tables[index];
                return ListTile(
                  title: Text(t),
                  selected: _selectedTable == t,
                  leading: const Icon(Icons.table_chart),
                  onTap: () => _selectTable(t),
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          // Right Area: Data Grid
          Expanded(
            child: Column(
              children: [
                if (_selectedTable != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Viewing Table: $_selectedTable",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showEditDialog(null),
                          icon: const Icon(Icons.add),
                          label: const Text("Add New Row"),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _selectedTable == null
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Text(
                                  "Connect to Backend & Select a Table",
                                ),
                              ),
                            )
                          : DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                Colors.indigo.withOpacity(0.3),
                              ),
                              columns: [
                                ..._columns.map(
                                  (col) => DataColumn(
                                    label: Text(
                                      "${col['name']}\n(${col['type']})",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const DataColumn(label: Text("Actions")),
                              ],
                              rows: _rows
                                  .map(
                                    (row) => DataRow(
                                      cells: [
                                        ..._columns.map(
                                          (col) => DataCell(
                                            Text(row[col['name']].toString()),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () =>
                                                    _showEditDialog(row),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () =>
                                                    _deleteRow(row),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        color: Colors.indigo,
        child: Text(
          "Status: $_status",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
