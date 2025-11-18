import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:recipes_app/core/themes/app_theme.dart';
import 'package:recipes_app/data/datasources/recipe_local_data_source.dart';
import 'package:recipes_app/data/datasources/recipe_remote_data_source.dart';
import 'package:recipes_app/data/repositories/recipe_repository_impl.dart';
import 'package:recipes_app/domain/use_cases/cache_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/filter_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/get_cached_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/get_recipes_use_case.dart';
import 'package:recipes_app/presentation/bloc/recipes/recipes_bloc.dart';
import 'package:recipes_app/presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dio = Dio();
  
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  runApp(MyApp(dio: dio));
}

class MyApp extends StatefulWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final isDark = await AppTheme.getSavedTheme();
    setState(() {
      _isDarkTheme = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Создаем зависимости
    final remoteDataSource = RecipeRemoteDataSourceImpl(dio: widget.dio);
    final localDataSource = RecipeLocalDataSourceImpl();
    final repository = RecipeRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // Создаем UseCases
    final getRecipesUseCase = GetRecipesUseCase(repository: repository);
    final getCachedRecipesUseCase = GetCachedRecipesUseCase(repository: repository);
    final cacheRecipesUseCase = CacheRecipesUseCase(repository: repository);
    final filterRecipesUseCase = FilterRecipesUseCase();

    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipesBloc>(
          create: (context) => RecipesBloc(
            getRecipesUseCase: getRecipesUseCase,
            getCachedRecipesUseCase: getCachedRecipesUseCase,
            cacheRecipesUseCase: cacheRecipesUseCase,
            filterRecipesUseCase: filterRecipesUseCase,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Recipes App',
        theme: _isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}