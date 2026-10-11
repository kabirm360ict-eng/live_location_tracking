import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import '../../domain/entity/job_post_request_entity.dart';
import '../bloc/job_post_bloc.dart';

class CreateJobPostPage extends StatefulWidget {
  const CreateJobPostPage({super.key});

  @override
  State<CreateJobPostPage> createState() => _CreateJobPostPageState();
}

class _CreateJobPostPageState extends State<CreateJobPostPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobIdController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _vacancyController = TextEditingController();
  final TextEditingController _timezoneController =
      TextEditingController(text: 'Asia/Dhaka');

  @override
  void dispose() {
    _jobIdController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _vacancyController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !mounted) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final isoString = combined.toUtc().toIso8601String();

    setState(() {
      if (isStart) {
        _startTimeController.text = isoString;
      } else {
        _endTimeController.text = isoString;
      }
    });
  }

  void _submitJobPost(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final request = JobPostRequestEntity(
        jobId: int.tryParse(_jobIdController.text.trim()),
        startTime: DateTime.parse(_startTimeController.text.trim()).toIso8601String(),
        endTime: DateTime.parse(_endTimeController.text.trim()).toIso8601String(),
        vacancy: int.tryParse(_vacancyController.text.trim()),
        timezone: _timezoneController.text.trim(),
      );

      context.read<JobPostBloc>().add(CreateJobPostEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Job Post'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: BlocConsumer<JobPostBloc, JobPostState>(
              listener: (context, state) {
                if (state is CreateJobPostSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        state.response.message ??
                            'Job post created successfully!',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is CreateJobPostFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is CreateJobPostLoadingState;
    
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSize.p16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFormField(
                          controller: _jobIdController,
                          labelText: 'Job ID',
                          hintText: 'Enter Job ID (e.g. 9)',
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.work_outline),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter job ID';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        AppSize.gapH16,
                        CustomTextFormField(
                          controller: _startTimeController,
                          labelText: 'Start Time',
                          hintText: 'Select Start Time',
                          readOnly: true,
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _pickDateTime(isStart: true),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select start time';
                            }
                            return null;
                          },
                        ),
                        AppSize.gapH16,
                        CustomTextFormField(
                          controller: _endTimeController,
                          labelText: 'End Time',
                          hintText: 'Select End Time',
                          readOnly: true,
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _pickDateTime(isStart: false),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select end time';
                            }
                            return null;
                          },
                        ),
                        AppSize.gapH16,
                        CustomTextFormField(
                          controller: _vacancyController,
                          labelText: 'Vacancy',
                          hintText: 'Enter Vacancy (e.g. 1)',
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.people_outline),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter vacancy count';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        AppSize.gapH16,
                        CustomTextFormField(
                          controller: _timezoneController,
                          labelText: 'Timezone',
                          hintText: 'e.g. Asia/Dhaka',
                          prefixIcon: const Icon(Icons.public),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter timezone';
                            }
                            return null;
                          },
                        ),
                        AppSize.gapH24,
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _submitJobPost(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSize.p16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSize.radiusMd),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Job Post',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}