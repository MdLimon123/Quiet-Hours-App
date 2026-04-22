import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/session_controller.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _apartmentController;
  bool _notificationsEnabled = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<SessionController>().profile.value;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _neighborhoodController = TextEditingController(
      text: profile?.neighborhoodLabel ?? '',
    );
    _apartmentController = TextEditingController(
      text: profile?.apartmentLabel ?? '',
    );
    _notificationsEnabled = profile?.notificationsEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _neighborhoodController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await Get.find<SessionController>().saveProfile(
        name: _nameController.text,
        neighborhoodLabel: _neighborhoodController.text,
        apartmentLabel: _apartmentController.text,
        notificationsEnabled: _notificationsEnabled,
      );
      if (!mounted) {
        return;
      }
      Get.offAllNamed(AppRoutes.shell);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF4F8FB), Color(0xFFD9EDF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 12),
                Text(
                  'আপনার পাড়াকে যোগ করুন',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF123247),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'এই অ্যাপের idea খুব simple: আপনার প্রয়োজন হলে পাশের মানুষদের politely signal যাবে, যাতে একটু সময় শব্দ কম থাকে।',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF325A73),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'আপনার নাম',
                              hintText: 'যেমন: রাইয়ান',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().length < 2) {
                                return 'কমপক্ষে ২ অক্ষরের নাম দিন';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _neighborhoodController,
                            decoration: const InputDecoration(
                              labelText: 'পাড়া / মহল্লা / রোড',
                              hintText: 'যেমন: Banani Road 11',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().length < 3) {
                                return 'এলাকার নাম দিন';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _apartmentController,
                            decoration: const InputDecoration(
                              labelText: 'বাড়ি / ফ্ল্যাট (ঐচ্ছিক)',
                              hintText: 'যেমন: House 22, Flat B2',
                            ),
                          ),
                          const SizedBox(height: 18),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() => _notificationsEnabled = value);
                            },
                            title: const Text('Gentle notification চালু রাখুন'),
                            subtitle: const Text(
                              'প্রতিবেশীদের অনুরোধ ও আপনার alert status দেখাবে',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _isSaving ? null : _save,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            child: Text(
                              _isSaving ? 'সংরক্ষণ হচ্ছে...' : 'চালু করুন',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: const Color(0xFF123247),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          'Recommended product flow',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. প্রোফাইল সেটআপ\n2. পাড়া join\n3. Quiet request তৈরি\n4. প্রতিবেশীদের gentle alert\n5. সময় শেষ হলে request auto/manuel close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
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
