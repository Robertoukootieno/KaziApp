import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

/// A responsive wrapper for DataTable2 that adapts to different screen sizes
class ResponsiveDataTable extends StatelessWidget {
  final List<DataColumn2> columns;
  final List<DataRow2> rows;
  final double? columnSpacing;
  final double? horizontalMargin;
  final double? minWidth;
  final bool sortAscending;
  final int? sortColumnIndex;

  final double? dataRowHeight;
  final double? headingRowHeight;
  final bool showCheckboxColumn;
  final Widget? empty;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing,
    this.horizontalMargin,
    this.minWidth,
    this.sortAscending = true,
    this.sortColumnIndex,

    this.dataRowHeight,
    this.headingRowHeight,
    this.showCheckboxColumn = true,
    this.empty,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        
        if (screenWidth < 600) {
          // Mobile: Use card-based layout instead of table
          return _buildMobileCardLayout();
        } else if (screenWidth < 900) {
          // Tablet: Use simplified table with fewer columns
          return _buildTabletTable();
        } else {
          // Desktop: Use full table
          return _buildDesktopTable();
        }
      },
    );
  }

  Widget _buildDesktopTable() {
    return DataTable2(
      columns: columns,
      rows: rows,
      columnSpacing: columnSpacing ?? 12,
      horizontalMargin: horizontalMargin ?? 12,
      minWidth: minWidth ?? 800,
      sortAscending: sortAscending,
      sortColumnIndex: sortColumnIndex,

      dataRowHeight: dataRowHeight,
      headingRowHeight: headingRowHeight,
      showCheckboxColumn: showCheckboxColumn,
      empty: empty,
    );
  }

  Widget _buildTabletTable() {
    // For tablet, show only the most important columns
    final importantColumns = _getImportantColumns();
    final simplifiedRows = _getSimplifiedRows(importantColumns.length);
    
    return DataTable2(
      columns: importantColumns,
      rows: simplifiedRows,
      columnSpacing: columnSpacing ?? 8,
      horizontalMargin: horizontalMargin ?? 8,
      minWidth: 600,
      sortAscending: sortAscending,
      sortColumnIndex: sortColumnIndex != null && sortColumnIndex! < importantColumns.length 
          ? sortColumnIndex 
          : null,

      dataRowHeight: dataRowHeight,
      headingRowHeight: headingRowHeight,
      showCheckboxColumn: false, // Hide checkbox on tablet
      empty: empty,
    );
  }

  Widget _buildMobileCardLayout() {
    if (rows.isEmpty) {
      return empty ?? const Center(
        child: Text('No data available'),
      );
    }

    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildMobileRowCard(row, index),
          ),
        );
      },
    );
  }

  Widget _buildMobileRowCard(DataRow2 row, int index) {
    final cells = row.cells;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show the first few most important cells
        for (int i = 0; i < cells.length && i < 4; i++)
          if (i < columns.length)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      _getColumnLabel(columns[i]),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: cells[i].child,
                  ),
                ],
              ),
            ),
        
        // Show actions if available (usually the last column)
        if (cells.isNotEmpty && cells.length > 4)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cells.last.child,
              ],
            ),
          ),
      ],
    );
  }

  List<DataColumn2> _getImportantColumns() {
    // For tablet, show only the first 4-5 most important columns
    final maxColumns = columns.length > 5 ? 5 : columns.length;
    return columns.take(maxColumns).toList();
  }

  List<DataRow2> _getSimplifiedRows(int maxColumns) {
    return rows.map((row) {
      final simplifiedCells = row.cells.take(maxColumns).toList();
      return DataRow2(
        cells: simplifiedCells,
        selected: row.selected,
        onSelectChanged: row.onSelectChanged,
        onTap: row.onTap,
        onLongPress: row.onLongPress,
        color: row.color,
      );
    }).toList();
  }

  String _getColumnLabel(DataColumn2 column) {
    final widget = column.label;
    if (widget is Text) {
      return widget.data ?? '';
    }
    return '';
  }
}


