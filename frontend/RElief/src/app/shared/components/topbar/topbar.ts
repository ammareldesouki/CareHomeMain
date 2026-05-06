import { Component, Input, Output, EventEmitter, ChangeDetectionStrategy, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { BreadcrumbComponent, BreadcrumbItem } from '../../layout/breadcrumb/breadcrumb';

@Component({
  selector: 'app-topbar',
  standalone: true,
  imports: [CommonModule, BreadcrumbComponent],
  templateUrl: './topbar.html',
  styleUrls: ['./topbar.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class TopbarComponent {
  @Input() breadcrumbs: BreadcrumbItem[] = [];
  @Input() userInitials = '';
  @Input() searchPlaceholder = 'Search…';
  @Output() searchChange = new EventEmitter<string>();

  private authService = inject(AuthService);
  private router = inject(Router);

  onLogout(): void {
    this.authService.logout();
    this.router.navigate(['/']);
  }
}
