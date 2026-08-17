import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posdevices/business/menu_rules.dart';
import 'package:posdevices/data/models/menu_item_model.dart';

import '../../../core/widgets/stat_card.dart';
import '../controllers/manager_controller.dart';

class ManagerHomeView extends StatelessWidget {
  const ManagerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManagerController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showMenuItemSheet(context, controller),
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF030712), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Obx(
                    () => Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2DD4BF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFF2DD4BF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.venue?.name ?? 'The Copper Fox',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Manager dashboard',
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const TabBar(
                  labelColor: Color(0xFF2DD4BF),
                  unselectedLabelColor: Color(0xFF94A3B8),
                  indicatorColor: Color(0xFF2DD4BF),
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Menu'),
                    Tab(text: 'Orders'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _OverviewTab(controller: controller),
                      _MenuTab(controller: controller),
                      _OrdersTab(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final ManagerController controller;

  const _OverviewTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          const Text(
            'Good evening, Alex',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Menu and order activity in one place.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              StatCard(
                label: 'Items',
                value: controller.totalItems.toString(),
                icon: Icons.restaurant_menu_rounded,
                accent: const Color(0xFF2DD4BF),
              ),
              StatCard(
                label: 'Available',
                value: controller.availableItems.toString(),
                icon: Icons.check_circle_rounded,
                accent: const Color(0xFF34D399),
              ),
              StatCard(
                label: 'Sold out',
                value: controller.soldOutItems.toString(),
                icon: Icons.block_rounded,
                accent: const Color(0xFFF87171),
              ),
              StatCard(
                label: 'Devices',
                value: controller.activeDevices.toString(),
                icon: Icons.devices_rounded,
                accent: const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuTab extends StatelessWidget {
  final ManagerController controller;

  const _MenuTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: TextField(
            onChanged: controller.updateSearch,
            decoration: const InputDecoration(
              hintText: 'Search menu items...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ChoiceChip(
                    label: const Text('All'),
                    selected: controller.selectedCategoryId.value == null,
                    onSelected: (_) => controller.selectCategory(null),
                  );
                }

                final category = controller.categories[index - 1];
                return ChoiceChip(
                  label: Text(category.name),
                  selected: controller.selectedCategoryId.value == category.id,
                  onSelected: (_) => controller.selectCategory(category.id),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: controller.categories.length + 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(
            () => ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              itemCount: controller.filteredMenu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.filteredMenu[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  MenuRules.formatPrice(item.price),
                                  style: const TextStyle(
                                    color: Color(0xFF2DD4BF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  MenuRules.getStatusText(item),
                                  style: TextStyle(
                                    color: item.available
                                        ? const Color(0xFF34D399)
                                        : const Color(0xFFF87171),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  controller.toggleAvailability(item),
                              icon: Icon(
                                item.available
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                              ),
                              label: Text(
                                item.available
                                    ? 'Mark sold out'
                                    : 'Mark available',
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => showMenuItemSheet(
                                context,
                                controller,
                                item: item,
                              ),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            TextButton.icon(
                              onPressed: () => controller.deleteItem(item.id),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _OrdersTab extends StatelessWidget {
  final ManagerController controller;

  const _OrdersTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: controller.orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = controller.orders[index];
          return Card(
            child: ListTile(
              title: Text(
                'Order ${order.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${order.items.length} items • ${order.createdAt}',
                style: const TextStyle(color: Color(0xFF94A3B8)),
              ),
              trailing: Text(
                MenuRules.formatPrice(order.total),
                style: const TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItemSheet extends StatefulWidget {
  final ManagerController controller;
  final MenuItemModel? item;

  const _MenuItemSheet({required this.controller, required this.item});

  @override
  State<_MenuItemSheet> createState() => _MenuItemSheetState();
}

class _MenuItemSheetState extends State<_MenuItemSheet> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late String categoryId;
  late bool available;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nameController = TextEditingController(text: item?.name ?? '');
    descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    priceController = TextEditingController(
      text: (item?.price ?? 0).toStringAsFixed(2),
    );
    categoryId = item?.categoryId ??
        (widget.controller.categories.isNotEmpty
            ? widget.controller.categories.first.id
            : 'cat_burger');
    available = item?.available ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF020617),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isEdit ? 'Edit Menu Item' : 'Add Menu Item',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: categoryId,
                  items: widget.controller.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => categoryId = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Available',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: available,
                  onChanged: (value) => setState(() => available = value),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final id =
                          widget.item?.id ??
                          'item_${now.millisecondsSinceEpoch}';
                      await widget.controller.saveItem(
                        MenuItemModel(
                          id: id,
                          venueId: widget.controller.venue?.id ?? 'venue_001',
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          price:
                              double.tryParse(priceController.text.trim()) ?? 0,
                          categoryId: categoryId,
                          available: available,
                          imageUrl: widget.item?.imageUrl,
                          createdAt: widget.item?.createdAt ?? now,
                          updatedAt: now,
                        ),
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(isEdit ? 'Save Changes' : 'Create Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showMenuItemSheet(
  BuildContext context,
  ManagerController controller, {
  MenuItemModel? item,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _MenuItemSheet(controller: controller, item: item),
  );
}
