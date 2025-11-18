import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/presentation/bloc/recipes/recipes_bloc.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();
  bool? _hasImage;
  int? _maxPrepTime;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    context.read<RecipesBloc>().add(
          FilterRecipes(
            searchQuery: _searchController.text,
            hasImage: _hasImage,
            maxPrepTime: _maxPrepTime,
          ),
        );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Фильтры'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Фильтр по изображению
                  const Text('Изображение:'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool?>(
                          title: const Text('Все'),
                          value: null,
                          groupValue: _hasImage,
                          onChanged: (value) {
                            setState(() => _hasImage = value);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool?>(
                          title: const Text('С фото'),
                          value: true,
                          groupValue: _hasImage,
                          onChanged: (value) {
                            setState(() => _hasImage = value);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool?>(
                          title: const Text('Без фото'),
                          value: false,
                          groupValue: _hasImage,
                          onChanged: (value) {
                            setState(() => _hasImage = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Фильтр по времени
                  const Text('Макс. время приготовления (мин):'),
                  Slider(
                    value: _maxPrepTime?.toDouble() ?? 0,
                    min: 0,
                    max: 120,
                    divisions: 12,
                    label: _maxPrepTime == null ? 'Любое' : '${_maxPrepTime} мин',
                    onChanged: (value) {
                      setState(() {
                        _maxPrepTime = value == 0 ? null : value.toInt();
                      });
                    },
                  ),
                  Text(_maxPrepTime == null ? 'Любое время' : 'До $_maxPrepTime минут'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasImage = null;
                      _maxPrepTime = null;
                    });
                  },
                  child: const Text('Сбросить'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _applyFilters();
                  },
                  child: const Text('Применить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по названию или ингредиентам...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Фильтры',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}