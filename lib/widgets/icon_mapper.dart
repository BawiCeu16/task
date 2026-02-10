// lib/widgets/icon_mapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

/// Maps Material [Icons] to equivalent Remix icons where possible.
/// If no Remix equivalent is defined, returns the original [materialIcon].
IconData remixIcon(IconData materialIcon) {
  // Define a mapping from Material icon code points to Remix IconData.
  // This map only includes icons used in the app.
  final mapping = <int, IconData>{
    Icons.list_outlined.codePoint: FlutterRemix.list_unordered,
    Icons.list.codePoint: FlutterRemix.list_unordered,
    Icons.list_alt.codePoint: FlutterRemix.list_check,
    Icons.list_alt_outlined.codePoint: FlutterRemix.list_check,
    Icons.search_outlined.codePoint: FlutterRemix.search_line,
    Icons.search.codePoint: FlutterRemix.search_line,
    Icons.folder_open_outlined.codePoint: FlutterRemix.folder_open_line,
    Icons.folder.codePoint: FlutterRemix.folder_line,
    Icons.label_outline.codePoint: FlutterRemix.price_tag_line,
    Icons.label.codePoint: FlutterRemix.price_tag_line,
    Icons.settings.codePoint: FlutterRemix.settings_line,
    Icons.add.codePoint: FlutterRemix.add_line,
    Icons.edit.codePoint: FlutterRemix.edit_line,
    Icons.info.codePoint: FlutterRemix.information_line,
    Icons.delete.codePoint: FlutterRemix.delete_bin_line,
    Icons.sort.codePoint: FlutterRemix.sort_desc,
    Icons.arrow_drop_down.codePoint: FlutterRemix.arrow_down_s_line,
    Icons.check.codePoint: FlutterRemix.check_line,
    Icons.toc.codePoint: FlutterRemix.menu_5_line,
    Icons.toc_outlined.codePoint: FlutterRemix.menu_5_line,
    Icons.folder_open.codePoint: FlutterRemix.folder_open_line,
    Icons.folder_outlined.codePoint: FlutterRemix.folder_line,
    Icons.palette_outlined.codePoint: FlutterRemix.palette_line,
    Icons.edit_note.codePoint: FlutterRemix.edit_line,
    Icons.info_outline.codePoint: FlutterRemix.information_line,
    Icons.article.codePoint: FlutterRemix.article_line,
    Icons.new_releases.codePoint: FlutterRemix.fire_line,
    Icons.save.codePoint: FlutterRemix.save_line,
    Icons.upload.codePoint: FlutterRemix.upload_line,
    Icons.light_mode.codePoint: FlutterRemix.sun_line,
    Icons.dark_mode.codePoint: FlutterRemix.moon_line,
    Icons.restore.codePoint: FlutterRemix.refresh_line,
    Icons.close.codePoint: FlutterRemix.close_line,
    Icons.chevron_right.codePoint: FlutterRemix.arrow_right_s_line,
    Icons.circle_outlined.codePoint: FlutterRemix.checkbox_blank_circle_line,
    Icons.check_circle.codePoint: FlutterRemix.checkbox_circle_line,
    Icons.create_new_folder.codePoint: FlutterRemix.folder_add_line,
    Icons.block.codePoint: FlutterRemix.forbid_line,
    Icons.image.codePoint: FlutterRemix.image_line,
    Icons.work.codePoint: FlutterRemix.briefcase_line,
    Icons.home.codePoint: FlutterRemix.home_line,
    Icons.person.codePoint: FlutterRemix.user_line,
    Icons.favorite.codePoint: FlutterRemix.heart_line,
    Icons.star.codePoint: FlutterRemix.star_line,
    Icons.music_note.codePoint: FlutterRemix.music_line,
    Icons.smartphone.codePoint: FlutterRemix.smartphone_line,
  };

  return mapping[materialIcon.codePoint] ?? materialIcon;
}
