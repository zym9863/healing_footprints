import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/mood_entry.dart';
import '../../providers/mood_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/energy_level_slider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/mood_selector.dart';

class MoodEntryScreen extends StatefulWidget {
  final MoodEntry? entry; // 如果是编辑模式，则传入现有的记录

  const MoodEntryScreen({super.key, this.entry});

  @override
  State<MoodEntryScreen> createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _triggerController = TextEditingController();
  final _tagController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  MoodLevel _selectedMoodLevel = MoodLevel.neutral;
  double _energyLevel = 0.5;
  List<String> _selectedTags = [];
  List<String> _suggestedTags = [];
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.entry != null;

    if (_isEditMode) {
      // 填充现有数据
      _selectedDate = widget.entry!.date;
      _selectedMoodLevel = widget.entry!.moodLevel;
      _descriptionController.text = widget.entry!.description;
      _triggerController.text = widget.entry!.triggerEvent ?? '';
      _selectedTags = List.from(widget.entry!.tags);
      _energyLevel = widget.entry!.energyLevel;
    }

    // 加载标签建议
    _loadSuggestedTags();
  }

  Future<void> _loadSuggestedTags() async {
    final tags =
        await Provider.of<MoodProvider>(context, listen: false).getAllTags();
    setState(() {
      _suggestedTags = tags;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _triggerController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? '编辑情绪记录' : '新建情绪记录')),
      body:
          _isLoading
              ? const LoadingIndicator(message: '保存中...')
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateTimePicker(),
                      const SizedBox(height: 24),
                      _buildMoodSelector(),
                      const SizedBox(height: 24),
                      _buildEnergyLevelSlider(),
                      const SizedBox(height: 24),
                      _buildDescriptionField(),
                      const SizedBox(height: 16),
                      _buildTriggerField(),
                      const SizedBox(height: 24),
                      _buildTagsSection(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildDateTimePicker() {
    final dateFormat = DateFormat('yyyy年MM月dd日 HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('日期和时间', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppTheme.smallSpacing),
        InkWell(
          onTap: _pickDateTime,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.smallSpacing,
              horizontal: AppTheme.spacing,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    if (!mounted) return;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildMoodSelector() {
    return MoodSelector(
      selectedMood: _selectedMoodLevel,
      onMoodSelected: (mood) {
        setState(() {
          _selectedMoodLevel = mood;
        });
      },
    );
  }

  Widget _buildEnergyLevelSlider() {
    return EnergyLevelSlider(
      value: _energyLevel,
      onChanged: (value) {
        setState(() {
          _energyLevel = value;
        });
      },
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('描述你的感受', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppTheme.smallSpacing),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: '描述你的情绪和感受...'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请描述你的感受';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTriggerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('触发事件（可选）', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppTheme.smallSpacing),
        TextFormField(
          controller: _triggerController,
          decoration: const InputDecoration(hintText: '是什么引发了这种情绪？'),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('标签', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppTheme.smallSpacing),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(hintText: '添加标签'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.smallSpacing),
                  ElevatedButton(onPressed: _addTag, child: const Text('添加')),
                ],
              ),
              if (_suggestedTags.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing),
                Text(
                  '建议标签:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: AppTheme.smallSpacing),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _suggestedTags
                          .map(
                            (tag) => ActionChip(
                              label: Text(tag),
                              backgroundColor: AppTheme.secondaryColor
                                  .withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                              ),
                              onPressed: () {
                                if (!_selectedTags.contains(tag)) {
                                  setState(() {
                                    _selectedTags.add(tag);
                                  });
                                }
                              },
                            ),
                          )
                          .toList(),
                ),
              ],
              if (_selectedTags.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing),
                Text('已选标签:', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppTheme.smallSpacing),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _selectedTags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                              ),
                              deleteIconColor: AppTheme.primaryColor,
                              onDeleted: () {
                                setState(() {
                                  _selectedTags.remove(tag);
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagController.clear();
      });
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.smallBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveEntry,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(_isEditMode ? '更新记录' : '保存记录'),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 获取provider引用，避免在异步操作中使用BuildContext
      final provider = Provider.of<MoodProvider>(context, listen: false);

      final entry = MoodEntry(
        id: _isEditMode ? widget.entry!.id : null,
        date: _selectedDate,
        moodLevel: _selectedMoodLevel,
        description: _descriptionController.text.trim(),
        triggerEvent:
            _triggerController.text.trim().isEmpty
                ? null
                : _triggerController.text.trim(),
        tags: _selectedTags,
        energyLevel: _energyLevel,
      );

      if (_isEditMode) {
        await provider.updateEntry(entry);
      } else {
        await provider.addEntry(entry);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
