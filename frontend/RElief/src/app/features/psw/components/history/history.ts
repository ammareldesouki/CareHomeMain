import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { RouterModule } from '@angular/router';
import { DashboardShellComponent } from '../../../../shared/components/dashboard-shell/dashboard-shell';
import { SidebarItem } from '../../../../shared/components/sidebar/sidebar';
import { BreadcrumbItem } from '../../../../shared/layout/breadcrumb/breadcrumb';
import { PswApplicationsService } from '../../../../core/services/psw-applications.service';
import { NotificationService } from '../../../../core/services/notification.service';
import { CancelApplicationDto } from '../../../../core/models/api.models';

interface PswApplication {
  jobRequestId: string;
  jobRequestItemId: string;
  shiftId: string;
  offerId: string;
  offerTitle: string;
  date: string;
  startTime: string;
  endTime: string;
  status: string;
}

class PswApplicationPresenter {
  constructor(public app: PswApplication) {}

  get statusLabel(): string {
    switch (this.app.status) {
      case 'Accepted':            return 'accepted';
      case 'RejectedByAdmin':
      case 'RejectedByCareHome':  return 'rejected';
      case 'Canceled':            return 'cancelled';
      default:                    return 'pending';
    }
  }

  get rejectedBy(): string | null {
    if (this.app.status === 'RejectedByAdmin') return 'Admin';
    if (this.app.status === 'RejectedByCareHome') return 'Care Home';
    return null;
  }

  get statusDisplay(): string {
    switch (this.app.status) {
      case 'Accepted':            return 'Accepted';
      case 'RejectedByAdmin':     return 'Rejected by Admin';
      case 'RejectedByCareHome':  return 'Rejected by Care Home';
      case 'Canceled':            return 'Cancelled';
      default:                    return 'Pending';
    }
  }
}

@Component({
  selector: 'app-history',
  standalone: true,
  imports: [CommonModule, RouterModule, DatePipe, DashboardShellComponent],
  templateUrl: './history.html',
  styleUrl: './history.scss',
})
export class History implements OnInit {
  applications: PswApplicationPresenter[] = [];
  isLoading = true;
  selectedApp: PswApplicationPresenter | null = null;
  activeTab: 'all' | 'pending' | 'accepted' | 'rejected' | 'cancelled' = 'all';

  // Shell config
  userName = '';
  userInitials = '';
  readonly sidebarItems: SidebarItem[] = [
    { type: 'section', label: 'Workspace' },
    { type: 'link', label: 'Dashboard',        icon: '⌂', path: '/psw/dashboard' },
    { type: 'link', label: 'Available offers', icon: '≡', path: '/psw/offers' },
    { type: 'link', label: 'My applications',  icon: '⏱', path: '/psw/history' },
    { type: 'section', label: 'Account' },
    { type: 'link', label: 'Profile',          icon: '☺', path: '/psw/profile' },
  ];
  readonly breadcrumbs: BreadcrumbItem[] = [
    { label: 'Workspace' },
    { label: 'My Applications' },
  ];

  constructor(
    private pswApplicationsService: PswApplicationsService,
    private cdr: ChangeDetectorRef,
    private notifications: NotificationService
  ) {}

  ngOnInit(): void {
    this.loadApplications();
  }

  loadApplications(): void {
    this.isLoading = true;
    this.pswApplicationsService.getPswApplications().subscribe({
      next: (res: any) => {
        const raw: any[] = Array.isArray(res) ? res : (res?.data ?? res?.items ?? []);
        this.applications = raw.map(a => new PswApplicationPresenter(a as PswApplication));
        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  viewRequest(app: PswApplicationPresenter): void {
    this.selectedApp = app;
  }

  closeDetails(): void {
    this.selectedApp = null;
  }

  cancel(app: PswApplicationPresenter): void {
    if (!app?.app?.jobRequestItemId) {
      this.notifications.show('Cannot cancel: missing request id.', 'error');
      return;
    }
    const payload: CancelApplicationDto = { jobRequestItemId: app.app.jobRequestItemId };
    this.pswApplicationsService.cancelApplication(payload).subscribe({
      next: () => {
        this.notifications.show('Application cancelled successfully.', 'success');
        app.app.status = 'Canceled';
        this.cdr.detectChanges();
      },
      error: (err) => {
        this.notifications.show(err?.error?.message || 'Failed to cancel.', 'error');
      }
    });
  }

  getPendingCount(): number   { return this.applications.filter(a => a.statusLabel === 'pending').length; }
  getAcceptedCount(): number  { return this.applications.filter(a => a.statusLabel === 'accepted').length; }
  getRejectedCount(): number  { return this.applications.filter(a => a.statusLabel === 'rejected').length; }
  getCancelledCount(): number { return this.applications.filter(a => a.statusLabel === 'cancelled').length; }

  setTab(tab: 'all' | 'pending' | 'accepted' | 'rejected' | 'cancelled'): void {
    this.activeTab = this.activeTab === tab ? 'all' : tab;
  }

  get filteredApplications(): PswApplicationPresenter[] {
    if (this.activeTab === 'all') return this.applications;
    return this.applications.filter(a => a.statusLabel === this.activeTab);
  }

  pillClass(status: string): string {
    if (status === 'accepted')  return 'pill--success';
    if (status === 'pending')   return 'pill--warn';
    if (status === 'rejected')  return 'pill--danger';
    return 'pill--neutral';
  }
}
