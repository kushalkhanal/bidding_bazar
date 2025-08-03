import 'dart:async';
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bidding_bazar/features/product/domain/entities/bidding_room_entity.dart';
import 'package:bidding_bazar/features/product/domain/usecases/get_all_bidding_rooms.dart';
import 'package:bidding_bazar/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // --- State variables for manual pagination ---
  final List<BiddingRoomEntity> _products = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isFirstLoad = true;
  String? _error;
  // ---

  @override
  void initState() {
    super.initState();
    // Fetch the initial page of data
    _fetchPage();

    // Add a listener to the ScrollController to detect when we're at the bottom
    _scrollController.addListener(() {
      // Check if we're at the bottom of the list and not already loading
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        // If there are more pages to load
        if (_currentPage < _totalPages) {
          _fetchPage();
        }
      }
    });

    // Add a listener for the search field to implement debouncing
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        // When the user stops typing, trigger a refresh (new search)
        _refresh();
      });
    });
  }

  Future<void> _fetchPage() async {
    // Prevent multiple simultaneous fetches
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (_isFirstLoad) {
        _error = null;
      }
    });

    try {
      final usecase = sl<GetAllBiddingRooms>();
      final result = await usecase(
          PageParams(page: _currentPage, searchQuery: _searchController.text));

      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
          });
        },
        (paginatedData) {
          setState(() {
            _products.addAll(paginatedData.products);
            _totalPages = paginatedData.totalPages;
            // Increment the page number for the next fetch
            _currentPage++;
            _isFirstLoad = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      // Always set loading to false after the fetch is complete
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Resets the state and fetches the first page again
  Future<void> _refresh() async {
    setState(() {
      _products.clear();
      _currentPage = 1;
      _totalPages = 1;
      _isFirstLoad = true;
    });
    await _fetchPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutButtonPressed());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        border: InputBorder.none,
        filled: false,
      ),
    );
  }

  Widget _buildBody() {
    // Case 1: Initial loading state
    if (_isFirstLoad && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Case 2: Error on first load
    if (_isFirstLoad && _error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _refresh, child: const Text('Try Again'))
          ],
        ),
      );
    }
    // Case 3: No items found after a search/fetch
    if (_products.isEmpty && !_isLoading) {
       return const Center(child: Text("No products found."));
    }

    // Case 4: Display the grid of products
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      // Add 1 to the item count to show the loading indicator at the bottom
      itemCount: _products.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        // If it's the last item and we are loading, show the indicator
        if (index == _products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        // Otherwise, show the product card
        return ProductCard(product: _products[index]);
      },
    );
  }
}