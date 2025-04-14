import 'package:fireguard_bo/features/news_screen/presentation/presenter/page/bloc/news_bloc.dart';
import 'package:fireguard_bo/features/news_screen/presentation/presenter/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
      create: (context) => NewsBloc()..add(const LoadNewsEvent()),
      child: const _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return switch (state) {
            NewsLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            NewsLoadedState(incidents: final incidents) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: incidents.length,
                itemBuilder: (context, index) {
                  final incident = incidents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NewsCard(
                      author: incident.reporter.name,
                      username: '@${incident.reporter.username}',
                      location: '${incident.location.lat}, ${incident.location.long}',
                      timeAgo: _getTimeAgo(incident.createdAt),
                      imageUrl: incident.photoUrl.isNotEmpty ? incident.photoUrl : 'https://picsum.photos/250?image=9',
                      description: incident.description,
                      severityLevel: incident.severityLevel,
                      status: incident.status,
                      isFireReport: incident.incidentType == 'fire',
                    ),
                  );
                },
              ),
            NewsErrorState(message: final message) => Center(
                child: Text(message),
              ),
            NewsInitial() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'hace ${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes}m';
    } else {
      return 'justo ahora';
    }
  }
}
