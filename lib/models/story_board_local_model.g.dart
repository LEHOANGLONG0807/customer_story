// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_board_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryBoardLocalModelAdapter extends TypeAdapter<StoryBoardLocalModel> {
  @override
  final int typeId = 1;

  @override
  StoryBoardLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryBoardLocalModel(
      id: fields[0] as int,
      title: fields[1] as String?,
      thumbnail: fields[2] as String?,
      chap: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StoryBoardLocalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.chap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBoardLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
