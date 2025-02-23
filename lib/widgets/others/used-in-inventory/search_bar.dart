import 'package:flutter/material.dart';

class SearchWithFilter extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String) onFilterSelected;
  final String selectedFilter;

  const SearchWithFilter({
    Key? key,
    required this.onSearch,
    required this.onFilterSelected,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  State<SearchWithFilter> createState() => _SearchWithFilterState();
}

class _SearchWithFilterState extends State<SearchWithFilter> {
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleFilterOptions() {
    if (_overlayEntry == null) {
      _showFilterOptions();
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showFilterOptions() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _selectFilter(String filter) {
    widget.onFilterSelected(filter == widget.selectedFilter ? '' : filter);
    _removeOverlay();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(-144, 60),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterOption('Low stock'),
                  const Divider(height: 1),
                  _buildFilterOption('In stock'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String filter) {
    return InkWell(
      onTap: () => _selectFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              widget.selectedFilter == filter
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              size: 20,
              color: widget.selectedFilter == filter
                  ? Color(0xFF5044FC)
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              filter,
              style: TextStyle(
                fontSize: 16,
                color: widget.selectedFilter == filter
                    ? Color(0xFF5044FC)
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                  hintText: "Search inventory...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onChanged: widget.onSearch,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: _toggleFilterOptions,
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: widget.selectedFilter.isNotEmpty
                        ? Color(0xFF5044FC)
                        : Colors.black87,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
