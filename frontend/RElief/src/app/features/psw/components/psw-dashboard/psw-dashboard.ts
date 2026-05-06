import { Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { forkJoin, of } from 'rxjs';
import { catchError, take } from 'rxjs/operators';

import { DashboardShellComponent } from '../../../../shared/components/dashboard-shell/dashboard-shell';
import { SidebarItem } from '../../../../shared/components/sidebar/sidebar';
import { StatCardComponent } from '../../../../shared/layout/stat-card/stat-card';
import { BreadcrumbItem } from '../../../../shared/layout/breadcrumb/breadcrumb';

import { AuthService } from '../../../../core/services/auth.service';
import { PswApplicationsService } from '../../../../core/services/psw-applications.service';
import { OffersService } from '../../../../core/services/offers.service';

interface ApplicationRow {
  title: string;
  shift: string;
  status: string;
}

interface OfferRow {
  id: string;
  title: string;
  location: string;
  rate: number | null;
  shift: string;
}

@Component({
  selector: 'app-psw-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule, DashboardShellComponent, StatCardComponent],
  templateUrl: './psw-dashboard.html',
  styleUrls: ['./psw-dashboard.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PswDashboard implements OnInit {
  private authService = inject(AuthService);
  private pswApps = inject(PswApplicationsService);
  private offersService = inject(OffersService);
  private cdr = inject(ChangeDetectorRef);
  private router = inject(Router);

  isLoading = true;

  // Greeting
  greetingName = '';
  greetingInitials = '';

  // Stats
  pendingCount = 0;
  acceptedCount = 0;
  rejectedCount = 0;
  rating = '—';
  profilePct = 83;

  // Recent applications
  myApplications: ApplicationRow[] = [];

  // Nearby offers
  nearbyOffers: OfferRow[] = [];

  // Sidebar + topbar config
  readonly sidebarItems: SidebarItem[] = [
    { type: 'section', label: 'Workspace' },
    { type: 'link', label: 'Dashboard',          icon: '⌂', path: '/psw/dashboard' },
    { type: 'link', label: 'Available offers',   icon: '≡', path: '/psw/offers' },
    { type: 'link', label: 'My applications',    icon: '⏱', path: '/psw/history' },
    { type: 'section', label: 'Account' },
    { type: 'link', label: 'Profile',            icon: '☺', path: '/psw/profile' },
  ];

  readonly breadcrumbs: BreadcrumbItem[] = [
    { label: 'Workspace' },
    { label: 'Dashboard' },
  ];

  ngOnInit(): void {
    this.authService.loadUserProfile().pipe(take(1)).subscribe({
      next: (profile: any) => {
        const firstName = profile?.firstName ?? profile?.FirstName ?? '';
        const lastName = profile?.lastName ?? profile?.LastName ?? '';
        const name = `${firstName} ${lastName}`.trim();
        this.greetingName = name || 'there';
        const initials =
          ((firstName[0] ?? '') + (lastName[0] ?? '')).toUpperCase() || '??';
        this.greetingInitials = initials;
        this.cdr.markForCheck();
      },
    });

    forkJoin({
      apps: this.pswApps.getPswApplications().pipe(catchError(() => of([]))),
      offers: this.offersService.browseOffers({ pageIndex: 1, pageSize: 4 }).pipe(catchError(() => of([]))),
    })
      .pipe(take(1))
      .subscribe({
        next: ({ apps, offers }) => {
          this.pendingCount = apps.filter(
            (a: any) => (a.status ?? '').toLowerCase() === 'pending' || a.status === 'QualifiedByAdmin'
          ).length;
          this.acceptedCount = apps.filter(
            (a: any) => (a.status ?? '').toLowerCase() === 'accepted'
          ).length;
          this.rejectedCount = apps.filter(
            (a: any) =>
              ['rejectedbyadmin', 'rejectedbycarehome'].includes((a.status ?? '').toLowerCase())
          ).length;

          // Build application rows (latest 2)
          this.myApplications = apps.slice(0, 2).map((a: any) => ({
            title: a.offerTitle ?? 'Shift',
            shift: a.date
              ? `${a.date}  ${(a.startTime ?? '').slice(0, 5)} – ${(a.endTime ?? '').slice(0, 5)}`
              : '—',
            status: a.status ?? 'Unknown',
          }));

          // Build offer rows
          this.nearbyOffers = (offers as any[]).slice(0, 2).map((o: any) => ({
            id: o.id ?? o.Id ?? '',
            title: o.title ?? o.Title ?? 'Offer',
            location: o.city ?? o.City ?? o.address ?? o.Address ?? 'Nearby',
            rate: o.hourlyRate ?? o.HourlyRate ?? null,
            shift: '—',
          }));

          this.sidebarItems[2].badge = apps.length || undefined;

          this.isLoading = false;
          this.cdr.markForCheck();
        },
        error: () => {
          this.isLoading = false;
          this.cdr.markForCheck();
        },
      });
  }

  get greetingTime(): string {
    const h = new Date().getHours();
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  pillClass(status: string): string {
    const s = (status ?? '').toLowerCase();
    if (s === 'accepted') return 'pill--success';
    if (s === 'pending' || s === 'qualifiedbyadmin') return 'pill--warn';
    if (s.includes('rejected')) return 'pill--danger';
    return 'pill--neutral';
  }

  pillLabel(status: string): string {
    const s = (status ?? '').toLowerCase();
    if (s === 'accepted') return 'Accepted';
    if (s === 'pending' || s === 'qualifiedbyadmin') return 'Pending';
    if (s.includes('rejected')) return 'Rejected';
    return status;
  }

  applyNow(offer: OfferRow): void {
    this.router.navigate(['/psw/offers']);
  }
}
