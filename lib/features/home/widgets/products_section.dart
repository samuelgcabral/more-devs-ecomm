import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.products,
    required this.onProductTap,
  });

  final bool isLoading;
  final bool hasError;
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  final ScrollController _scrollController = ScrollController();

  static final List<Product> _fakeProducts = List.filled(
    4,
    Product(
      category: 'Categoria do produto',
      brand: 'Marca do produto',
      name: 'Nome do produto',
      imageUrl: '',
      price: 0,
      description: 'Descrição do produto',
    ),
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || widget.isLoading) return;
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent <= 0) return;

    // Claim the event so the enclosing vertical ListView doesn't also scroll.
    GestureBinding.instance.pointerSignalResolver.register(event, (
      PointerSignalEvent event,
    ) {
      final scrollEvent = event as PointerScrollEvent;
      // Translate vertical mouse wheel movement into horizontal scrolling.
      final double delta = scrollEvent.scrollDelta.dy != 0
          ? scrollEvent.scrollDelta.dy
          : scrollEvent.scrollDelta.dx;
      final double target = (_scrollController.offset + delta).clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      if (target != _scrollController.offset) {
        _scrollController.jumpTo(target);
      }
      // Stop the browser / OS from also scrolling the page (web & desktop).
      scrollEvent.respond(allowPlatformDefault: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Produtos',
                style: AppTextStyle.subTitle.copyWith(fontSize: 20),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (widget.hasError)
          const Text('Problema ao resgatar produtos')
        else
          Builder(
            builder: (context) {
              final items = widget.isLoading ? _fakeProducts : widget.products;

              return Skeletonizer(
                enabled: widget.isLoading,
                child: Listener(
                  onPointerSignal: _handlePointerSignal,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: widget.isLoading
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    child: IntrinsicHeight(
                      child: Row(
                        children: items.map((Product product) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: 150,
                              child: ProductCard(
                                product: product,
                                onTap: () => widget.onProductTap(product),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
