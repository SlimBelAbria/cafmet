import 'package:cafmet/core/services/program_service.dart';
import 'package:cafmet/core/theme.dart';
import 'package:cafmet/ui/widgets/pdf_viewer_screen.dart';
import 'package:cafmet/ui/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cafmet/ui/screens/login_screen.dart';
import 'package:cafmet/ui/screens/map_screen.dart';
import 'package:cafmet/ui/screens/notifications_screen.dart';
import 'package:cafmet/ui/screens/scan_screen.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class HomePage extends StatefulWidget {
  final String? userRole;
  final String? username;
  const HomePage({Key? key,this.username, this.userRole}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isBottomNavBarVisible = true;



  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
      _isBottomNavBarVisible = index != 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _isBottomNavBarVisible = index != 4;
          });
        },
        children: [
          Center(child: HomePageContent(
            userRole: widget.userRole, 
            username: widget.username,
          )),
          const Center(child: MapScreen()),
          Center(
            child: NotificationsWidget(
              csvUrl: 'https://docs.google.com/spreadsheets/d/e/2PACX-1vS3s2CodS5ElcAHye4YBwyQV5i7ZwuNiySbNMFagMRImyeMnsTSa1Ps32WZrM91qGHuNb7VwiaTln1t/pub?gid=0&single=true&output=csv',
              userRole: widget.userRole,
            ),
          ),
          if (widget.userRole == 'admin')
            Center(child: ScanScreen(userRole: widget.userRole)),
        ],
      ),
      bottomNavigationBar: _isBottomNavBarVisible ? _buildBottomNavigation(context) : null,
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Iconsax.map), label: 'Map'),
      const BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: 'Notifications'),
    ];

    if (widget.userRole == 'admin') {
      bottomNavItems.add(
        const BottomNavigationBarItem(icon: Icon(Iconsax.scan), label: 'Scan'),
      );
    }

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xffEE751B),
      unselectedItemColor: const Color(0xff285F74),
      type: BottomNavigationBarType.fixed,
      items: bottomNavItems,
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffEE751B),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final String? userRole;
  final String? username;
  const HomePageContent({Key? key,this.username, this.userRole}) : super(key: key);

  @override
  HomePageContentState createState() => HomePageContentState();
}
class Event {
  final int date;
  final String title;
  final String time;
  final String location;
  final String speaker;
  final bool hasJoinButton;
  final Color color;
  final bool isConcurrent;
  final String sessionCode;
  final bool hasProgram;  // Shows "View Program" button
  final String? programKey; // Key to lookup in JSON (defaults to sessionCode)

  Event({
    required this.date,
    required this.title,
    required this.time,
    required this.location,
    required this.speaker,
    this.hasJoinButton = false,
    required this.color,
    this.isConcurrent = false,
    required this.sessionCode,
    this.hasProgram = false,
    this.programKey,
  });

  // Helper getter
  String get effectiveProgramKey => programKey ?? sessionCode;
}

final List<Event> allEvents = [
  // April 22 Events
  Event(
    date: 22,
    title: 'Opening Ceremony - Cérémonie d\'ouverture',
    time: '8:30 AM - 10:30 AM',
    location: 'SIDI BOUSSAID',
    speaker: '',
    color: openColor,
    sessionCode: 'OPEN',
  ),
  Event(
    date: 22,
    title: 'Coffee Break / Pause-café',
    time: '10:30 AM - 11:00 AM',
    location: 'Lounge Area',
    speaker: '',
    color: breakColor,
    sessionCode: 'BREAK',
  ),
  Event(
    date: 22,
    title: 'Plenary Conference 1',
    time: '11:00 AM - 11:45 AM',
    location: 'SIDI BOUSSAID',
    speaker: 'M. Himbert - M.Sadli',
    color: cpColor,
    sessionCode: 'PL1',
  ),
  Event(
    date: 22,
    title: 'Plenary Conference 2',
    time: '11:45 AM - 12:30 PM',
    location: 'SIDI BOUSSAID',
    speaker: 'PTB',
    color: cpColor,
    sessionCode: 'PL2',
  ),
  Event(
    date: 22,
    title: 'Forummesure Posters',
    time: '12:30 AM - 01:00 PM',
    location: 'SIDI BOUSSAID',
    speaker: '',
    color: forummesureColor,
    sessionCode: 'FORUMESURE',
  ),
    Event(
    date: 22,
    title: 'Lunch Break / Pause-déjeuner',
    time: '01:00 AM - 02:30 PM',
    location: '',
    speaker: '',
    color: lunchColor,
    sessionCode: 'BREAK',
  ),
  
  Event(
    date: 22,
    title: 'Panel 1: African Strategy for Metrological Traceability',
    time: '2:30 PM - 4:00 PM',
    location: 'SIDI BOUSSAID',
    speaker: 'Z.Ben Achour & L.Khiari',
    color: cpColor,
    isConcurrent: false,
    sessionCode: 'PL3',
  ),
  Event(
    date: 22,
    title: 'Coffee Break / Pause-café',
    time: '04:00 AM - 04:30 AM',
    location: 'Lounge Area',
    speaker: '',
    color: breakColor,
    sessionCode: 'BREAK',
  ),
  Event(
    date: 22,
    title: 'Panel 2: Metrology, Accreditation, and Quality Control in Industry',
    time: '4:30 PM - 6:00 PM',
     location: 'SIDI BOUSSAID',
    speaker: 'Y.Ahoule & G.Calchera',
    color: cpColor,
    isConcurrent: false,
    sessionCode: 'PL4',
  ),
  // April 23 Events
 

  
  Event(
    date: 23,
    title: 'Session 1: Metrology in industry',
    time: '8:45 AM - 12:30 AM',
    location: 'KAIROUAN',
    speaker: '',
    color: sColor,
    isConcurrent: true,
    sessionCode: 'S1',
    hasProgram: true,
    programKey: 'S1',
  ),
  Event(
    date: 23,
    title: 'Session 2: Scientific Metrology',
     time: '8:45 AM - 12:30 AM',
    location: 'SIDI BOUSSAID',
    speaker: '',
    color: sColor,
    isConcurrent: true,
    sessionCode: 'S2',
    hasProgram: true,
    programKey: 'S2',
  ),
  Event(
    date: 23,
    title: 'Session 3: AI and Metrology',
    time: '8:45 AM - 12:30 AM',
    location: 'SFAX',
    speaker: '',
   color:sColor,
    isConcurrent: true,
    sessionCode: 'S3',
    hasProgram: true,
    programKey: 'S3',
  ),
   Event(
    date: 23,
    title: 'Session 4:  Agri-Food, Environment, and Health',
    time: '8:45 AM - 12:30 AM',
    location: 'SOUSSE',
    speaker: '',
    color: sColor,
    isConcurrent: true,
    sessionCode: 'S4',
    hasProgram: true,
    programKey: 'S4',
  ),
   Event(
    date: 23,
    title: 'Session 5: National Metrology',
    time: '8:45 AM - 12:30 AM',
    location: 'KERKENNAH',
    
    speaker: '',
    color: sColor,
    isConcurrent: true,
    sessionCode: 'S5',
    hasProgram: true,
    programKey: 'S5',
  ),

   Event(
    date: 22,
    title: 'Lunch Break / Pause-déjeuner',
    time: '01:00 AM - 02:30 PM',
    location: '',
    speaker: '',
    color: lunchColor,
    sessionCode: 'BREAK',
  ),

  Event(
    date: 23,
    title: 'Forumesure & Posters: Technical Presentations',
    time: '02:30 AM - 04:00 PM',
    location: 'SIDI BOUSSAID / EL KHIMA',
    speaker: '',
    color: forummesureColor,
    sessionCode: 'FORUMESURE',
  ),
  Event(
    date: 23,
    title: 'T1: Machine & Deep Learning Theory and Metrological Applications',
    time: '2:30 PM - 4:00 PM',
    location: 'SFAX',
    speaker: 'A.Charki',
    color: tColor,
    isConcurrent: true,
    sessionCode: 'T1',
  ),
  Event(
    date: 23,
    title: 'T2: Methods and IT Tools Applicable to the Operational Planning of an Accreditation Project',
    time: '2:30 PM - 4:00 PM',
    location: 'KERKENNAH',
    speaker: 'P.ROCHERz',
    color: tColor,
    isConcurrent: true,
    sessionCode: 'T2',
  ),
 
   
  Event(
    date: 23,
    title: 'Gala Dinner',
    time: '8:00 PM - 11:00 PM',
    location: '',
    speaker: '',
    color: Colors.pink[100]!,
    sessionCode: 'GALA',
  ),

  // April 24 Events
  Event(
    date: 24,
    title: 'T3: Metrological requirements according to ISO 15189 (2022) in a medical biology laboratory',
    time: '8:45 AM - 12:00 AM',
    location: 'KAIROUAN',
    speaker: 'Z.BEN ACHOUR & N.HADDAOUI',
    isConcurrent: true,
    color: tColor,
    sessionCode: 'T3',
  ),
  Event(
    date: 24,
    title: 'T4: Measurement uncertainty and traceability in a testing laboratory',
  time: '8:45 AM - 12:00 AM',
    location: 'SFAX',
    speaker: 'M.HIMBERT',
    color: tColor,
    
    isConcurrent: true,
    sessionCode: 'T4',
  ),
  Event(
    date: 24,
    title: 'T5: DC Resistance Measurement: Different Possible Configurations – Shunt, Medium, and High Resistances',
    time: '8:45 AM - 12:00 AM',
    location: 'SOUSSE',
    speaker: 'Y.LOUHICHI',
    color: tColor,
    isConcurrent: true,
    sessionCode: 'T5',
  ),
  Event(
    date: 24,
    title: 'Lunch Break / Pause-déjeuner',
    time: '01:00 AM - 02:30 PM',
    location: 'Lounge Area',
    speaker: '',
    color: breakColor,
    sessionCode: 'BREAK',
  ),
  Event(
    date: 24,
    title: 'T6: Interlaboratory Comparison According to ISO 17043 (2023); Interpretation of Proficiency Testing Results Based on the Principles of ISO 13528 (2022)',
    time: '2:30 PM - 6:00 PM',
    location: 'SOUSSE',
    speaker: 'Z.BEN ACHOUR & A.GALLAS',
    isConcurrent: true,
    color: tColor,
    sessionCode: 'T6',
  ),
    Event(
    date: 24,
    title: 'T7: Applications of Uncertainty to Dimensional and Electrical Cases: Contribution of Calibration',
    time: '2:30 PM - 6:00 PM',
    location: 'KAIROUAN',
    speaker: 'G.CALCHERA & W.TOUAYAR',
    isConcurrent: true,
    color: tColor,
    sessionCode: 'T7',
  ),
      Event(
    date: 24,
    title: 'T8: Metrological Approach at INRAE and Management of Measurement Error: Practical Cases of Research Unit Support',
    time: '2:30 PM - 6:00 PM',
    location: 'SFAX',
    speaker: 'A.JAULIN',
    isConcurrent: true,
    color: tColor,
    sessionCode: 'T8',
  ),
  Event(
    date: 24,
    title: 'Closing Session / Session de clôture',
    time: '6:00 PM - 8:00 PM',
    location: '',
    speaker: '',
    color: Colors.blue[100]!,
    sessionCode: 'CLOSE',
  ),

  // April 25 Events
  Event(
    date: 25,
    title: 'Theoretical and practical Training: Volume metrology - Calibration of micropipettes',
    time: '8:30 AM - 06:00 PM',
    location: '',
    speaker: 'Mounir Ben Achour',
    color: Colors.blueGrey[100]!,
    sessionCode: 'TR1',
  ),
 
  // April 26 Events
  Event(
    date: 26,
    title: 'Theoretical and practical Training: Volume metrology - Calibration of micropipettes',
    time: '8:30 AM - 06:00 PM',
    location: '',
    speaker: 'Mounir Ben Achour',
    color: Colors.blueGrey[100]!,
    sessionCode: 'TR2',
  ),
];

class HomePageContentState extends State<HomePageContent> with SingleTickerProviderStateMixin {
  final List<String> _weekDays = ['Tue', 'Wed', 'Thu', 'Fri ', 'Sat '];
  final List<int> _dates = [22, 23, 24, 25, 26];
  int _selectedDate = 22;
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  List<Event> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _filteredEvents = _getEventsForDate(_selectedDate);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDate(int date) {
    return allEvents.where((event) => event.date == date).toList();
  }

  void _filterEvents(String query) {
    setState(() {
      _filteredEvents = _getEventsForDate(_selectedDate)
          .where((event) =>
              event.title.toLowerCase().contains(query.toLowerCase()) ||
              event.location.toLowerCase().contains(query.toLowerCase()) ||
              event.speaker.toLowerCase().contains(query.toLowerCase()) ||
              event.sessionCode.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showEventDetails(Event event) {
    final concurrentEvents = _filteredEvents
        .where((e) => e.time == event.time && e.sessionCode != event.sessionCode)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.sessionCode,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(event.time),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text(event.location),
              ],
            ),
            if (event.speaker.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 8),
                  Text("Speaker: ${event.speaker}"),
                ],
              ),
            ],
            if (concurrentEvents.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Concurrent Sessions:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              ...concurrentEvents.map((e) => ListTile(
                title: Text(e.title),
                subtitle: Text('${e.sessionCode} • ${e.location}'),
                dense: true,
              )),
            ],
            const SizedBox(height: 20),
            if (event.hasJoinButton)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Join Session"),
              ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildCalendar(context),
          Expanded(
            child: _filteredEvents.isEmpty
                ? const Center(
                    child: Text(
                      'No events found',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : _buildCombinedScrollView(context),
          ),
          if (widget.userRole == 'pro')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: CustomButton(
                onPressed: () {},
                buttonText: 'Professional Calendar',
              ),
            ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'CAFMET 2025',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(onPressed: (){
             Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  UserBadgeScreen(user: widget.username ?? '', role:widget.userRole ?? '')
                          ),
                        );
        }, 
        icon: const Icon(MaterialCommunityIcons.qrcode, color: Color(0xff285F74))),
        
        IconButton(
          icon: const Icon(Icons.picture_as_pdf, color: Color(0xff285F74)),
          onPressed: (){
            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PdfViewerScreen(
                              pdfUrl: 'https://drive.google.com/uc?export=download&id=16nk9UyxcR4AKNgZdfm33hMsdYDlnKPUn',
                            ),
                          ),
                        );
          } ,
        ),
        IconButton(
          icon: const Icon(Iconsax.logout, color: Color(0xffEE751B)),
          onPressed: _logout,
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        cursorColor: Colors.black,
        controller: _searchController,
        onChanged: _filterEvents,
        decoration: InputDecoration(
          hintText: 'Search sessions, speakers, or locations...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final hasEvents = allEvents.any((event) => event.date == date);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _filteredEvents = _getEventsForDate(_selectedDate);
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _dates[index] == _selectedDate
                    ? const Color(0xffEE751B)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekDays[index],
                    style: TextStyle(
                      color: _dates[index] == _selectedDate
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.toString(),
                    style: TextStyle(
                      color: _dates[index] == _selectedDate
                          ? Colors.white
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!hasEvents)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _dates[index] == _selectedDate
                              ? Colors.white
                              : Colors.grey[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCombinedScrollView(BuildContext context) {
    return ListView.builder(
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    event.time.split(' - ')[0],
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showEventDetails(event),
                    child: _buildEventItem(event),
                  ),
                ),
              ],
            ),
            if (index < _filteredEvents.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
                indent: 16,
                endIndent: 16,
              ),
          ],
        );
      },
    );
  }
Future<void> _showProgramDialog(Event event) async {
  try {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Load program
    final program = await ProgramService.getProgram(event.effectiveProgramKey);
    
    // Dismiss loading
    Navigator.of(context).pop();
    
    if (program == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Program not found')),
      );
      return;
    }

    // Show program dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(program.title),
            Text(
              'Session ${event.sessionCode}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProgramInfoRow(Icons.person, 'Chair: ${program.chairman}'),
                _buildProgramInfoRow(Icons.location_on, program.location),
                _buildProgramInfoRow(Icons.access_time, event.time),
                const Divider(height: 24),
                ...program.program.map((item) => _buildProgramItem(item)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

Widget _buildProgramInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(child: Text(text)),
      ],
    ),
  );
}

Widget _buildProgramItem(ProgramItem item) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.time,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(item.title),
        Text(
          item.speaker,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const Divider(height: 16),
      ],
    ),
  );
}



  Widget _buildEventItem(Event event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(12),
        border: event.isConcurrent
            ? Border.all(color: Colors.orange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.sessionCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (event.isConcurrent) ...[
                const SizedBox(width: 8),
                const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                const Text(
                  'Concurrent',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
           if (event.hasProgram)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.list_alt, size: 16),
              label: const Text('View Program'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffEE751B),
              ),
              onPressed: () => _showProgramDialog(event),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          if (event.speaker.isNotEmpty)
            Text(
              'Speaker: ${event.speaker}',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            '${event.time} • ${event.location}',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w100,
            ),
          ),
          if (event.hasJoinButton) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xffEE751B),
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}