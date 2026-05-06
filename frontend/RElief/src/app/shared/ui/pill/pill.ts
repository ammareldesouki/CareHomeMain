import { Component, Input, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';

export type PillVariant = 'success' | 'warn' | 'danger' | 'info' | 'neutral' | 'violet';

@Component({
  selector: 'app-pill',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './pill.html',
  styleUrls: ['./pill.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class PillComponent {
  @Input() variant: PillVariant = 'neutral';
}
