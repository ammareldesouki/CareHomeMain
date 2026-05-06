import { Component, Input, ChangeDetectionStrategy } from '@angular/core';
import { SidebarComponent, SidebarItem } from '../sidebar/sidebar';
import { TopbarComponent } from '../topbar/topbar';
import { BreadcrumbItem } from '../../layout/breadcrumb/breadcrumb';

@Component({
  selector: 'app-dashboard-shell',
  standalone: true,
  imports: [SidebarComponent, TopbarComponent],
  templateUrl: './dashboard-shell.html',
  styleUrls: ['./dashboard-shell.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DashboardShellComponent {
  @Input() sidebarItems: SidebarItem[] = [];
  @Input() breadcrumbs: BreadcrumbItem[] = [];
  @Input() userName = '';
  @Input() userRole = '';
  @Input() userInitials = '';
  @Input() searchPlaceholder = 'Search…';
}
