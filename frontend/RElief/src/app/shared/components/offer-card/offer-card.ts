import { Component, Input, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PillComponent, PillVariant } from '../../ui/pill/pill';
import { ButtonComponent } from '../../ui/button/button';

@Component({
  selector: 'app-offer-card',
  standalone: true,
  imports: [CommonModule, PillComponent, ButtonComponent],
  templateUrl: './offer-card.html',
  styleUrls: ['./offer-card.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class OfferCardComponent {
  @Input() title = '';
  @Input() location = '';
  @Input() rate = '';
  @Input() shift = '';
  @Input() type = '';
  @Input() spots: number | null = null;
  @Input() statusVariant: PillVariant = 'success';
  @Output() viewClicked = new EventEmitter<void>();
  @Output() applyClicked = new EventEmitter<void>();

  get spotLabel(): string {
    return this.spots != null ? `${this.spots} spot${this.spots !== 1 ? 's' : ''}` : '';
  }
}
