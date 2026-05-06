import { Component, Input, Output, EventEmitter, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PillComponent, PillVariant } from '../../ui/pill/pill';
import { ButtonComponent, ButtonVariant } from '../../ui/button/button';
import { AvatarComponent } from '../../ui/avatar/avatar';

export interface TableAction {
  label: string;
  event: string;
  variant?: ButtonVariant;
}

export interface TableColumn<T = Record<string, unknown>> {
  key: string;
  header: string;
  type?: 'text' | 'pill' | 'avatar-text' | 'actions';
  pillMap?: Record<string, PillVariant>;
  subKey?: string;
  actions?: TableAction[];
}

export interface TableRowAction<T = Record<string, unknown>> {
  event: string;
  row: T;
}

@Component({
  selector: 'app-table',
  standalone: true,
  imports: [CommonModule, PillComponent, ButtonComponent, AvatarComponent],
  templateUrl: './table.html',
  styleUrls: ['./table.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TableComponent<T extends Record<string, unknown> = Record<string, unknown>> {
  @Input() columns: TableColumn<T>[] = [];
  @Input() rows: T[] = [];
  @Output() rowAction = new EventEmitter<TableRowAction<T>>();

  getCellValue(row: T, key: string): unknown {
    return row[key];
  }

  getPillVariant(col: TableColumn<T>, value: unknown): PillVariant {
    return col.pillMap?.[String(value)] ?? 'neutral';
  }

  emit(event: string, row: T): void {
    this.rowAction.emit({ event, row });
  }
}
