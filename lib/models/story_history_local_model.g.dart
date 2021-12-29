// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_history_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryHistoryLocalModelAdapter
    extends TypeAdapter<StoryHistoryLocalModel> {
  @override
  final int typeId = 0;

  @override
  StoryHistoryLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryHistoryLocalModel(
      id: fields[0] as int,
      title: fields[1] as String?,
      thumbnail: fields[2] as String?,
      chap: fields[3] as int?,
      authorName: fields[4] as String?,
      chapterId: fields[5] as int,
      pageIndex: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StoryHistoryLocalModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.chap)
      ..writeByte(4)
      ..write(obj.authorName)
      ..writeByte(5)
      ..write(obj.chapterId)
      ..writeByte(6)
      ..write(obj.pageIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryHistoryLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
