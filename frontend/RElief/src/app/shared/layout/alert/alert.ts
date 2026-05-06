import { Component, Input, ChangeDetectionStrategy } from '@angular/core';

export type AlertVariant = 'success' | 'warn' | 'danger' | 'info';

@Component({
  selector: 'app-alert',
  standalone: true,
  templateUrl: './alert.html',
  styleUrls: ['./alert.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AlertComponent {
  @Input() variant: AlertVariant = 'info';
  @Input() title = '';

  readonly icons: Record<AlertVariant, string> = {
    success: '✓',
    warn: '!',
    danger: '✕',
    info: 'ℹ'
  };

  get icon(): string { return this.icons[this.variant]; }
}
