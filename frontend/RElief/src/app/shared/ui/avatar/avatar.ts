import { Component, Input, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-avatar',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './avatar.html',
  styleUrls: ['./avatar.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AvatarComponent {
  @Input() name = '';
  @Input() colorIndex: 1 | 2 | 3 | 4 | 5 | 6 = 1;
  @Input() size: 'sm' | 'md' | 'lg' = 'md';

  get initials(): string {
    const parts = this.name.trim().split(/\s+/);
    if (!parts[0]) return '?';
    return (parts[0][0] + (parts[1]?.[0] ?? '')).toUpperCase();
  }
}
