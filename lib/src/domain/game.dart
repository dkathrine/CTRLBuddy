// lib/src/domain/game.dart
import 'package:flutter/foundation.dart';

class Game {
  final String id;
  final String gameName;
  final String slug;
  final String? coverUrl;
  final int threadsCount;
  final String status; // "published", "pending", etc.
  final DateTime createdAt;
  final String createdBy; // uid or "system"

  Game({
    required this.id,
    required this.gameName,
    this.slug = '',
    this.coverUrl =
        'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png',
    this.threadsCount = 0,
    this.status = 'pending',
    DateTime? createdAt,
    this.createdBy = 'system',
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'gameName': gameName,
    'slug': slug,
    'coverUrl':
        coverUrl ??
        'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png',
    'threadsCount': threadsCount,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
  };

  /// Mirror of your Comment.fromMap style: pass the Firestore doc id and the map
  factory Game.fromMap(String id, Map<String, dynamic> map) {
    return Game(
      id: id,
      gameName: map['gameName'] as String? ?? '',
      slug:
          map['slug'] as String? ??
          (map['gameName'] as String? ?? '').toLowerCase().trim().replaceAll(
            ' ',
            '_',
          ),
      coverUrl:
          map['coverUrl'] as String? ??
          'https://res.cloudinary.com/dhdugvhj3/image/upload/v1762862497/CTRLBuddyThumbs/icon_vpicgq.png',
      threadsCount: (map['threadsCount'] is int)
          ? map['threadsCount'] as int
          : (map['threadsCount'] == null
                ? 0
                : (map['threadsCount'] as num).toInt()),
      status: map['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] as String? ?? 'system',
    );
  }
}
