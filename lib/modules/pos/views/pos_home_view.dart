import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posdevices/business/menu_rules.dart';

import '../controllers/pos_controller.dart';

// ============================================================
// RESPONSIVE BREAKPOINTS
// ============================================================
//
// < 700          -> Phone: single column menu, cart lives in a
//                   bottom sheet opened from a floating summary bar.
// 700 - 1099     -> Small tablet / narrow window: menu + order
//                   stacked vertically, both fully visible.
// >= 1100        -> Large tablet / desktop / web: menu + order
//                   side by side, exactly like a real POS terminal.
class Breakpoints {
  static const double phone = 700;
  static const double tablet = 1100;

  static bool isPhone(double w) => w < phone;
  static bool isTablet(double w) => w >= phone && w < tablet;
  static bool isDesktop(double w) => w >= tablet;
}

class PosHomeView extends StatelessWidget {
  const PosHomeView({super.key});

  static const Color primary = Color(0xFF0099A8);
  static const Color primaryDark = Color(0xFF007D8A);
  static const Color text = Color(0xFF111111);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color green = Color(0xFF16803C);
  static const Color surface = Color(0xFFF7F8FA);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PosController());

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Column(
              children: [
                _TopHeader(controller: controller, width: width),

                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (Breakpoints.isDesktop(width)) {
                        final orderWidth = width >= 1400 ? 460.0 : 400.0;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _MenuArea(
                                controller: controller,
                                width: width,
                              ),
                            ),
                            Container(width: 1, color: border),
                            SizedBox(
                              width: orderWidth,
                              child: _OrderArea(
                                controller: controller,
                                embedded: true,
                              ),
                            ),
                          ],
                        );
                      }

                      if (Breakpoints.isTablet(width)) {
                        return Column(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _MenuArea(
                                controller: controller,
                                width: width,
                              ),
                            ),
                            Container(height: 1, color: border),
                            SizedBox(
                              height: 360,
                              child: _OrderArea(
                                controller: controller,
                                embedded: true,
                              ),
                            ),
                          ],
                        );
                      }

                      return _MenuArea(controller: controller, width: width);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final width = MediaQuery.of(context).size.width;
          if (!Breakpoints.isPhone(width)) return const SizedBox.shrink();
          return _CartSummaryBar(controller: controller);
        },
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final PosController controller;
  final double width;

  const _TopHeader({required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    final bool compact = Breakpoints.isPhone(width);
    final double hPad = compact ? 18 : 40;

    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: PosHomeView.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: compact ? 38 : 42,
            height: compact ? 38 : 42,
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),

          const SizedBox(width: 12),

          Text(
            'PluginOS',
            style: TextStyle(
              fontSize: compact ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: PosHomeView.text,
              letterSpacing: -0.6,
            ),
          ),

          if (!compact) ...[const SizedBox(width: 16), const _OnlineBadge()],

          const Spacer(),

          if (!compact) ...[const _TableSelector(), const SizedBox(width: 12)],

          if (Breakpoints.isPhone(width)) ...[
            _CartIconWithBadge(controller: controller),
            const SizedBox(width: 4),
          ],

          _IconBox(icon: Icons.settings_outlined, onTap: () {}),
        ],
      ),
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _StatusDot(),
        SizedBox(width: 7),
        Text(
          'Online',
          style: TextStyle(
            color: PosHomeView.green,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: PosHomeView.green,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBox({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: PosHomeView.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 21, color: PosHomeView.text),
      ),
    );
  }
}

class _TableSelector extends StatefulWidget {
  const _TableSelector();

  @override
  State<_TableSelector> createState() => _TableSelectorState();
}

class _TableSelectorState extends State<_TableSelector> {
  String _selected = 'Table 04';

  static const List<String> _tables = [
    'Table 01',
    'Table 02',
    'Table 03',
    'Table 04',
    'Table 05',
    'Table 06',
    'Table 07',
    'Table 08',
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) => setState(() => _selected = value),
      itemBuilder: (context) => _tables
          .map(
            (table) => PopupMenuItem<String>(
              value: table,
              child: Row(
                children: [
                  Icon(
                    Icons.table_restaurant_outlined,
                    size: 18,
                    color: table == _selected
                        ? PosHomeView.primary
                        : PosHomeView.secondaryText,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    table,
                    style: TextStyle(
                      fontWeight: table == _selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: table == _selected
                          ? PosHomeView.primary
                          : const Color.fromARGB(255, 59, 55, 55),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: PosHomeView.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.table_restaurant_outlined,
              size: 19,
              color: PosHomeView.text,
            ),
            const SizedBox(width: 9),
            Text(
              _selected,
              style: const TextStyle(
                color: PosHomeView.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: PosHomeView.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartIconWithBadge extends StatelessWidget {
  final PosController controller;

  const _CartIconWithBadge({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () => _openCartSheet(context, controller),
            icon: const Icon(
              Icons.shopping_bag_outlined,
              size: 25,
              color: PosHomeView.text,
            ),
          ),
          if (controller.cart.isNotEmpty)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '${controller.cart.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void _openCartSheet(BuildContext context, PosController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: PosHomeView.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: _OrderArea(controller: controller, embedded: false),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _CartSummaryBar extends StatelessWidget {
  final PosController controller;

  const _CartSummaryBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cart.isEmpty) return const SizedBox.shrink();

      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openCartSheet(context, controller),
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: PosHomeView.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x330099A8),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${controller.cart.length}',
                          style: const TextStyle(
                            color: PosHomeView.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'View Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      MenuRules.formatPrice(controller.total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _MenuArea extends StatelessWidget {
  final PosController controller;
  final double width;

  const _MenuArea({required this.controller, required this.width});

  @override
  Widget build(BuildContext context) {
    final bool compact = Breakpoints.isPhone(width);
    final double hPad = compact ? 18 : (Breakpoints.isTablet(width) ? 26 : 36);

    final double maxExtent = compact
        ? 165
        : (Breakpoints.isTablet(width) ? 200 : 240);
    final double aspect = compact ? 0.64 : 0.78;

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 22, hPad, compact ? 8 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (compact) ...[
            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: PosHomeView.text,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SearchField(controller: controller, fullWidth: true),
                ),
                const SizedBox(width: 10),
                _IconBox(icon: Icons.tune_rounded, onTap: () {}),
              ],
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: Breakpoints.isTablet(width) ? 24 : 27,
                    fontWeight: FontWeight.w800,
                    color: PosHomeView.text,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: _SearchField(controller: controller, fullWidth: true),
                ),
                const SizedBox(width: 10),
                _IconBox(icon: Icons.tune_rounded, onTap: () {}),
              ],
            ),

          const SizedBox(height: 18),

          // CATEGORIES
          _CategoryTabs(controller: controller),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.filteredMenu.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 44,
                        color: Color(0xFFD1D5DB),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No menu items found',
                        style: TextStyle(
                          color: PosHomeView.secondaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.only(bottom: compact ? 100 : 20, right: 4),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxExtent,
                  mainAxisSpacing: compact ? 14 : 20,
                  crossAxisSpacing: compact ? 14 : 20,
                  childAspectRatio: aspect,
                ),
                itemCount: controller.filteredMenu.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredMenu[index];

                  return _MenuCard(
                    item: item,
                    compact: compact,
                    onAdd: item.available
                        ? () => controller.addItem(item)
                        : null,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final PosController controller;
  final bool fullWidth;

  const _SearchField({required this.controller, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: fullWidth ? double.infinity : null,
      child: TextField(
        onChanged: controller.updateSearch,
        style: const TextStyle(color: PosHomeView.text, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search menu items...',
          hintStyle: const TextStyle(
            color: PosHomeView.secondaryText,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: PosHomeView.secondaryText,
            size: 22,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          filled: true,
          fillColor: PosHomeView.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: PosHomeView.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final PosController controller;

  const _CategoryTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 42,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _CategoryButton(
              title: 'All',
              selected: controller.selectedCategoryId.value == null,
              onTap: () => controller.selectCategory(null),
            ),
            ...controller.categories.map((category) {
              return _CategoryButton(
                title: category.name,
                selected: controller.selectedCategoryId.value == category.id,
                onTap: () => controller.selectCategory(category.id),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? PosHomeView.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? PosHomeView.primary : PosHomeView.border,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x330099A8),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : PosHomeView.text,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onAdd;
  final bool compact;

  const _MenuCard({
    required this.item,
    required this.onAdd,
    this.compact = false,
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool available = widget.item.available == true;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: widget.onAdd != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _hovering
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E5E8)),
          boxShadow: [
            BoxShadow(
              color: _hovering
                  ? const Color(0x1F0099A8)
                  : const Color(0x12000000),
              blurRadius: _hovering ? 16 : 8,
              offset: Offset(0, _hovering ? 8 : 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: widget.compact ? 4 : 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _FoodImage(item: widget.item, available: available),
                  if (!available)
                    Container(
                      color: Colors.black.withOpacity(0.35),
                      alignment: Alignment.center,
                      child: const Text(
                        'SOLD OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              flex: widget.compact ? 5 : 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.compact ? 12 : 15,
                  widget.compact ? 9 : 12,
                  widget.compact ? 10 : 13,
                  widget.compact ? 8 : 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: PosHomeView.text,
                        fontSize: widget.compact ? 14 : 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      MenuRules.getCategoryDisplayName(
                        widget.item.categoryId as String? ?? '',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: PosHomeView.secondaryText,
                        fontSize: widget.compact ? 11 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: widget.compact ? 4 : 6),

                    Text(
                      MenuRules.formatPrice(widget.item.price),
                      style: TextStyle(
                        color: PosHomeView.primaryDark,
                        fontSize: widget.compact ? 13 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Flexible(child: SizedBox(height: 4)),

                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: available
                                ? PosHomeView.green
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            available ? 'Available' : 'Sold Out',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: available
                                  ? PosHomeView.green
                                  : const Color(0xFFDC2626),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onAdd,
                          child: Container(
                            width: widget.compact ? 28 : 32,
                            height: widget.compact ? 28 : 32,
                            decoration: BoxDecoration(
                              color: widget.onAdd != null
                                  ? PosHomeView.primary
                                  : const Color(0xFFD1D5DB),
                              shape: BoxShape.circle,
                              boxShadow: widget.onAdd != null && _hovering
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x400099A8),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: widget.compact ? 17 : 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  final dynamic item;
  final bool available;

  const _FoodImage({required this.item, required this.available});

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = _getImageUrl(item);

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF1F3F4),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: PosHomeView.primary,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _ImageFallback(available: available);
        },
      );
    }

    return _ImageFallback(available: available);
  }

  String? _getImageUrl(dynamic item) {
    try {
      return item.imageUrl;
    } catch (_) {
      return null;
    }
  }
}

class _ImageFallback extends StatelessWidget {
  final bool available;

  const _ImageFallback({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: available
              ? const [Color(0xFFE9F8F9), Color(0xFFD2F1F3)]
              : const [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
        ),
      ),
      child: Center(
        child: Icon(
          available ? Icons.fastfood_rounded : Icons.block_rounded,
          color: available ? PosHomeView.primary : const Color(0xFF9CA3AF),
          size: 48,
        ),
      ),
    );
  }
}

class _OrderArea extends StatelessWidget {
  final PosController controller;

  final bool embedded;

  const _OrderArea({required this.controller, this.embedded = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, embedded ? 24 : 4, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Order',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: PosHomeView.text,
                ),
              ),

              const SizedBox(width: 10),

              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F6F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.cart.length} Items',
                    style: const TextStyle(
                      color: PosHomeView.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Obx(
                () => TextButton.icon(
                  onPressed: controller.cart.isEmpty
                      ? null
                      : controller.clearCart,
                  icon: const Icon(Icons.delete_outline, size: 19),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Expanded(
            child: Obx(() {
              if (controller.cart.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 46,
                        color: Color(0xFFD1D5DB),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No items in order',
                        style: TextStyle(
                          color: PosHomeView.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap + on a menu item to add it',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 15),
                itemCount: controller.cart.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 26, color: PosHomeView.border),
                itemBuilder: (context, index) {
                  final item = controller.cart[index];

                  return _OrderItem(
                    item: item,
                    onIncrease: () {
                      controller.setQuantity(
                        item.menuItemId,
                        item.quantity + 1,
                      );
                    },
                    onDecrease: () {
                      if (item.quantity > 1) {
                        controller.setQuantity(
                          item.menuItemId,
                          item.quantity - 1,
                        );
                      } else {
                        controller.removeItem(item.menuItemId);
                      }
                    },
                    onDelete: () {
                      controller.removeItem(item.menuItemId);
                    },
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 10),

          _OrderSummary(controller: controller),

          const SizedBox(height: 16),

          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.cart.isEmpty
                    ? null
                    : () async {
                        await controller.placeOrder();

                        if (!embedded) Navigator.of(context).maybePop();

                        Get.snackbar(
                          'Order placed',
                          'Order has been successfully placed.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: PosHomeView.primary,
                          colorText: Colors.white,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PosHomeView.primary,
                  disabledBackgroundColor: const Color(0xFFD1D5DB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.cart.isEmpty
                            ? 'Place Order'
                            : 'Place Order • ${MenuRules.formatPrice(controller.total)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

class _OrderItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const _OrderItem({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final double itemTotal = item.price * item.quantity;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool narrow = constraints.maxWidth < 380;

        final image = Container(
          width: narrow ? 50 : 60,
          height: narrow ? 50 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFE6F6F8),
          ),
          clipBehavior: Clip.antiAlias,
          child: _CartImage(item: item),
        );

        final nameAndPrice = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: PosHomeView.text,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              MenuRules.formatPrice(item.price),
              style: const TextStyle(
                fontSize: 12,
                color: PosHomeView.secondaryText,
              ),
            ),
          ],
        );

        final qtyStepper = Container(
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9DEE2)),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SmallButton(icon: Icons.remove, onTap: onDecrease),
              SizedBox(
                width: 26,
                child: Center(
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              _SmallButton(icon: Icons.add, onTap: onIncrease),
            ],
          ),
        );

        final totalPrice = Text(
          MenuRules.formatPrice(itemTotal),
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: PosHomeView.text,
          ),
        );

        final deleteButton = SizedBox(
          width: 34,
          height: 34,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: PosHomeView.text,
            ),
          ),
        );

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  image,
                  const SizedBox(width: 12),
                  Expanded(child: nameAndPrice),
                  deleteButton,
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: narrow ? 62 : 0),
                child: Row(children: [qtyStepper, const Spacer(), totalPrice]),
              ),
            ],
          );
        }

        return Row(
          children: [
            image,
            const SizedBox(width: 12),
            Expanded(child: nameAndPrice),
            const SizedBox(width: 10),
            qtyStepper,
            const SizedBox(width: 10),
            SizedBox(width: 58, child: totalPrice),
            deleteButton,
          ],
        );
      },
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 26,
        height: 30,
        child: Icon(icon, size: 15, color: PosHomeView.text),
      ),
    );
  }
}

class _CartImage extends StatelessWidget {
  final dynamic item;

  const _CartImage({required this.item});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    try {
      imageUrl = item.imageUrl;
    } catch (_) {}

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.fastfood_rounded, color: PosHomeView.primary);
        },
      );
    }

    return const Icon(
      Icons.fastfood_rounded,
      color: PosHomeView.primary,
      size: 28,
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final PosController controller;

  const _OrderSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: PosHomeView.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Obx(
        () => Column(
          children: [
            _SummaryRow(
              label: 'Subtotal',
              value: MenuRules.formatPrice(controller.subtotal),
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Tax (8%)',
              value: MenuRules.formatPrice(controller.tax),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: PosHomeView.border, height: 1),
            ),
            _SummaryRow(
              label: 'Total',
              value: MenuRules.formatPrice(controller.total),
              total: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool total;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.total = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PosHomeView.text,
            fontSize: total ? 20 : 14,
            fontWeight: total ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: total ? PosHomeView.primaryDark : PosHomeView.text,
            fontSize: total ? 26 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
