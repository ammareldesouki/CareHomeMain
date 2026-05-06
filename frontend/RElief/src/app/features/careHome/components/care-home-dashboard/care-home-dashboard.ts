import {
  Component, OnInit, ChangeDetectionStrategy, ChangeDetectorRef, inject, signal
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { FormBuilder, FormGroup, FormArray, Validators, ReactiveFormsModule, FormsModule } from '@angular/forms';
import { forkJoin, of } from 'rxjs';
import { catchError, first, take } from 'rxjs/operators';

import { DashboardShellComponent } from '../../../../shared/components/dashboard-shell/dashboard-shell';
import { SidebarItem } from '../../../../shared/components/sidebar/sidebar';
import { StatCardComponent } from '../../../../shared/layout/stat-card/stat-card';
import { BreadcrumbItem } from '../../../../shared/layout/breadcrumb/breadcrumb';

import { OffersService } from '../../../../core/services/offers.service';
import { AuthService } from '../../../../core/services/auth.service';
import { NotificationService } from '../../../../core/services/notification.service';
import { CreateJobOfferDto } from '../../../../core/models/api.models';

interface ApplicationItem {
  applicantName: string;
  applicantEmail: string;
  offerTitle: string;
  shift: string;
  rate: number | null;
  requestId: string;
  colorIndex: 1|2|3|4|5|6;
  initials: string;
}

interface ActiveOffer {
  id: string;
  title: string;
  rate: number | null;
  applicantCount: number;
}

interface ScheduleItem {
  name: string;
  role: string;
  wing: string;
  startTime: string;
  endTime: string;
  tone: 'success' | 'brand' | 'warn';
}

const COLORS: (1|2|3|4|5|6)[] = [1,2,3,4,5,6];
function colorFor(i: number): 1|2|3|4|5|6 { return COLORS[i % 6]; }
function initials(name: string): string {
  const parts = (name || '').trim().split(/\s+/);
  return ((parts[0]?.[0] ?? '') + (parts[1]?.[0] ?? '')).toUpperCase() || '??';
}

@Component({
  selector: 'app-care-home-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule, ReactiveFormsModule, FormsModule, DashboardShellComponent, StatCardComponent],
  templateUrl: './care-home-dashboard.html',
  styleUrls: ['./care-home-dashboard.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CareHomeDashboard implements OnInit {
  private offersService = inject(OffersService);
  private authService = inject(AuthService);
  private notifications = inject(NotificationService);
  private cdr = inject(ChangeDetectorRef);
  private router = inject(Router);
  private fb = inject(FormBuilder);

  isLoading = true;
  showCreateModal = false;
  isSubmitting = false;

  homeTitle = 'Care Home';
  homeInitials = 'CH';

  // Stats
  activeOffers = 0;
  pendingApps = 0;
  shiftsCovered = '94%';
  // TODO: backend — spend MTD not yet available
  spendMtd: number | null = null;

  pendingApplications: ApplicationItem[] = [];
  activeOffersList: ActiveOffer[] = [];

  // Chart data (coverage bars — TODO: backend feed real data)
  readonly chartBars = [38,52,46,64,58,72,80,68,86,78,92,88];

  readonly sidebarItems: SidebarItem[] = [
    { type: 'section', label: 'Operations' },
    { type: 'link', label: 'Dashboard',    icon: '⌂', path: '/care-home' },
    { type: 'link', label: 'Job offers',   icon: '≡', path: '/care-home/history' },
    { type: 'link', label: 'Applications', icon: '☺', path: '/care-home/notifications' },
    { type: 'section', label: 'Home' },
    { type: 'link', label: 'Profile',      icon: '⌂', path: '/care-home/profile' },
  ];

  readonly breadcrumbs: BreadcrumbItem[] = [
    { label: 'Operations' },
    { label: 'Dashboard' },
  ];

  // Create offer form
  offerForm!: FormGroup;

  ngOnInit(): void {
    this.offerForm = this.fb.group({
      title:       ['', Validators.required],
      description: ['', Validators.required],
      position:    ['', Validators.required],
      address:     ['', Validators.required],
      address2:    ['', Validators.required],
      city:        ['', Validators.required],
      province:    ['', Validators.required],
      postalCode:  ['', Validators.required],
      hourlyRate:  [0,  [Validators.required, Validators.min(10)]],
      shifts: this.fb.array([this.createShift()]),
    });

    this.loadDashboard();
  }

  private loadDashboard(): void {
    forkJoin({
      offers: this.offersService.getOffers().pipe(catchError(() => of([]))),
    })
      .pipe(take(1))
      .subscribe({
        next: ({ offers }) => {
          const offerList = Array.isArray(offers) ? offers : (offers as any)?.items ?? [];

          this.activeOffers = offerList.length;
          this.activeOffersList = offerList.slice(0, 3).map((o: any) => ({
            id: o.id ?? '',
            title: o.title ?? o.Title ?? 'Offer',
            rate: o.hourlyRate ?? o.HourlyRate ?? null,
            applicantCount: (o.applications ?? o.Applications ?? []).length,
          }));

          // Collect pending applications from all offers
          const allApps: ApplicationItem[] = [];
          offerList.forEach((o: any, oi: number) => {
            const apps: any[] = o.applications ?? o.Applications ?? [];
            apps.filter((a: any) => {
              const s = (a.status ?? '').toLowerCase();
              return s === 'pending' || s === 'qualifiedbyadmin';
            }).forEach((a: any, ai: number) => {
              const name = a.pswName ?? a.applicantName ?? a.name ?? 'Applicant';
              allApps.push({
                applicantName: name,
                applicantEmail: a.email ?? a.pswEmail ?? '',
                offerTitle: o.title ?? o.Title ?? 'Offer',
                shift: '—', // TODO: backend — shift date per application
                rate: o.hourlyRate ?? o.HourlyRate ?? null,
                requestId: a.id ?? a.requestId ?? '',
                colorIndex: colorFor(oi + ai),
                initials: initials(name),
              });
            });
          });

          this.pendingApplications = allApps.slice(0, 5);
          this.pendingApps = allApps.length;

          this.sidebarItems[2].badge = this.activeOffers || undefined;
          this.sidebarItems[3].badge = this.pendingApps || undefined;

          this.isLoading = false;
          this.cdr.markForCheck();
        },
        error: () => {
          this.isLoading = false;
          this.cdr.markForCheck();
        },
      });
  }

  // ─── Create Offer ──────────────────────────────────────────────────────────
  get shifts(): FormArray { return this.offerForm.get('shifts') as FormArray; }
  createShift(): FormGroup {
    return this.fb.group({
      date: ['', Validators.required],
      startTime: ['08:00', Validators.required],
      endTime:   ['16:00', Validators.required],
    });
  }
  addShift(): void { this.shifts.push(this.createShift()); }
  removeShift(i: number): void { if (this.shifts.length > 1) this.shifts.removeAt(i); }

  openCreate(): void { this.showCreateModal = true; }
  closeCreate(): void { this.showCreateModal = false; }

  submitOffer(): void {
    if (this.offerForm.invalid) { this.offerForm.markAllAsTouched(); return; }
    const v = this.offerForm.value;
    const payload: CreateJobOfferDto = {
      Title: v.title, Description: v.description, Position: v.position,
      Address: v.address, Address2: v.address2, City: v.city,
      Province: v.province, PostalCode: v.postalCode,
      Latitude: 0, Longitude: 0, HourlyRate: +v.hourlyRate,
      Shifts: v.shifts.map((s: any) => ({
        Date: s.date,
        StartTime: s.startTime + ':00.0000000',
        EndTime: s.endTime + ':00.0000000',
      })),
    };
    this.isSubmitting = true;
    this.offersService.createOffer(payload).pipe(first()).subscribe({
      next: () => {
        this.notifications.show('Offer created successfully.', 'success');
        this.showCreateModal = false;
        this.isSubmitting = false;
        this.offerForm.reset({ hourlyRate: 0 });
        this.loadDashboard();
        this.cdr.markForCheck();
      },
      error: (err: any) => {
        const msg = err?.error?.message || 'Failed to create offer.';
        this.notifications.show(msg, 'error');
        this.isSubmitting = false;
        this.cdr.markForCheck();
      },
    });
  }

  get today(): string {
    return new Date().toLocaleDateString('en-GB', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
  }
}
