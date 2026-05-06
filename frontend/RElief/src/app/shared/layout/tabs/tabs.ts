import { Component, Input, Output, EventEmitter, ChangeDetectionStrategy, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-tabs',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './tabs.html',
  styleUrls: ['./tabs.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TabsComponent {
  @Input() set items(val: string[]) { this._items = val; }
  get items() { return this._items; }
  private _items: string[] = [];

  @Input() set activeIndex(val: number) { this._active.set(val); }
  @Output() change = new EventEmitter<number>();

  readonly _active = signal(0);

  select(index: number): void {
    this._active.set(index);
    this.change.emit(index);
  }
}
