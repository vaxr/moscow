import 'dart:html';
import 'dart:math';

import 'package:moscow/core/model/player.dart';
import 'package:moscow/core/model/units.dart';

void drawUnit(
    CanvasRenderingContext2D ctx, Unit unit, Point center, double size) {
  // square
  ctx.setStrokeColorRgb(64, 64, 64);
  ctx.setFillColorRgb(224, 224, 224);
  ctx.lineWidth = size / 32;
  final squareTopLeft = center + Point(-size / 2, -size / 2);
  ctx.beginPath();
  ctx.rect(squareTopLeft.x, squareTopLeft.y, size, size);
  ctx.fill();
  ctx.stroke();

  // unit symbol
  ctx.setStrokeColorRgb(0, 0, 0);
  if (unit.faction == Faction.German) {
    ctx.setFillColorRgb(102, 153, 153);
  } else {
    ctx.setFillColorRgb(204, 153, 0);
  }
  ctx.lineWidth = size / 24;
  final symbolW = 0.7 * size;
  final symbolH = symbolW / 1.5;
  final symbolTopLeft = center + Point(-symbolW / 2, -symbolH * 0.6);
  ctx.beginPath();
  ctx.rect(symbolTopLeft.x, symbolTopLeft.y, symbolW, symbolH);
  ctx.fill();
  ctx.stroke();
  switch (unit.unitType) {
    case UnitType.Infantry:
      ctx.moveTo(symbolTopLeft.x, symbolTopLeft.y);
      ctx.lineTo(symbolTopLeft.x + symbolW, symbolTopLeft.y + symbolH);
      ctx.moveTo(symbolTopLeft.x, symbolTopLeft.y + symbolH);
      ctx.lineTo(symbolTopLeft.x + symbolW, symbolTopLeft.y);
      ctx.stroke();
      break;
    case UnitType.Panzer:
      final padding = symbolH * 0.25;
      final radius = symbolH / 2 - padding;
      final left = symbolTopLeft.x + padding + radius;
      final right = symbolTopLeft.x + symbolW - padding - radius;
      final top = symbolTopLeft.y + padding;
      final bottom = symbolTopLeft.y + symbolH - padding;
      final middle = symbolTopLeft.y + symbolH / 2;
      ctx.moveTo(left, top);
      ctx.lineTo(right, top);
      ctx.moveTo(left, bottom);
      ctx.lineTo(right, bottom);
      ctx.arc(left, middle, radius, 0.5 * pi, 1.5 * pi);
      ctx.arc(right, middle, radius, 1.5 * pi, 0.5 * pi);
      ctx.stroke();
      break;
    default:
      break;
  }

  // text
  ctx.setFillColorRgb(0, 0, 0);
  ctx.textAlign = 'center';
  // header
  final headerText = UnitSizeSymbols[unit.size];
  final headerCenter = center + Point(0, -size * 0.32);
  ctx.font = 'normal bold ${(size * 0.15).round()}px sans-serif';
  ctx.fillText(headerText, headerCenter.x, headerCenter.y);
  // footer
  final footerText =
      '${unit.strength}${unit.isHalved ? '/${unit.fullStrength}' : ''} - ${unit.speed}';
  final footerCenter = center + Point(0, size * 0.44);
  ctx.font = 'normal bold ${(size * 0.26).round()}px sans-serif';
  ctx.fillText(footerText, footerCenter.x, footerCenter.y);
}
