import { Component, Input, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';

export type StatCardTone = 'brand' | 'success' | 'warn' | 'danger' | 'info';
export type DeltaDirection = 'up' | 'down' | 'neutral';

@Component({
  selector: 'app-stat-card',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './stat-card.html',
  styleUrls: ['./stat-card.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class StatCardComponent {
  @Input() label = '';
  @Input() value = '';
  @Input() delta = '';
  @Input() deltaDirection: DeltaDirection = 'up';
  @Input() icon = '';
  @Input() tone: StatCardTone = 'brand';
}
