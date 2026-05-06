import { ChangeDetectorRef, Component, OnInit, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { forkJoin, Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { DashboardShellComponent } from '../../../../shared/components/dashboard-shell/dashboard-shell';
import { SidebarItem } from '../../../../shared/components/sidebar/sidebar';
import { StatCardComponent } from '../../../../shared/layout/stat-card/stat-card';
import { BreadcrumbItem } from '../../../../shared/layout/breadcrumb/breadcrumb';
import {
  AdminService,
  extractAdminPagedResult,
} from '../../../../core/services/admin.service';
import { AuthService } from '../../../../core/services/auth.service';

function countPendingApplications(items: unknown[]): number {
  return items.filter((a) => {
    const r = a as Record<string, unknown>;
    const s = String(r['status'] ?? r['Status'] ?? '').toLowerCase();
    if (s === 'pending') return true;
    const sc = r['statusCode'] ?? r['StatusCode'];
    return sc === 1 || sc === '1';
  }).length;
}

interface UserRow {
  initials: string;
  name: string;
  email: string;
  subLabel: string;
  role: 'admin' | 'psw' | 'indiv';
  joined: string;
  colorIndex: 1|2|3|4|5|6;
}

interface VerifRow {
  initials: string;
  name: string;
  docType: string;
  submittedAgo: string;
  pswId: string;
  colorIndex: 1|2|3|4|5|6;
}

interface ActivityRow {
  icon: string;
  tone: 'success' | 'brand' | 'info' | 'warn';
  text: string;
  when: string;
}

const COLORS: (1|2|3|4|5|6)[] = [1,2,3,4,5,6];
function colorFor(i: number): 1|2|3|4|5|6 { return COLORS[i % 6]; }
function initials(name: string): string {
  const p = (name || '').trim().split(/\s+/);
  return ((p[0]?.[0] ?? '') + (p[1]?.[0] ?? '')).toUpperCase() || '??';
}

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterModule, DashboardShellComponent, StatCardComponent],
  templateUrl: './admin-dashboard.html',
  styleUrls: ['./admin-dashboard.scss'],
})
export class AdminDashboard implements OnInit {
  stats = { verifications: 0, applications: 0, offers: 0, users: 0 };
  isLoading = true;
  loadError: string | null = null;

  userRows: UserRow[] = [];
  verifRows: VerifRow[] = [];
  activityRows: ActivityRow[] = [];

  readonly sidebarItems: SidebarItem[] = [
    { type: 'section', label: 'Overview' },
    { type: 'link', label: 'Dashboard',         icon: '⌂', path: '/admin/dashboard' },
    { type: 'link', label: 'Users',             icon: '☺', path: '/admin/users' },
    { type: 'link', label: 'All offers',        icon: '≡', path: '/admin/offers' },
    { type: 'section', label: 'Moderation' },
    { type: 'link', label: 'PSW verifications', icon: '✓', path: '/admin/verifications' },
    { type: 'link', label: 'Applications',      icon: '⚐', path: '/admin/applications' },
  ];

  readonly breadcrumbs: BreadcrumbItem[] = [
    { label: 'Overview' },
    { label: 'Dashboard' },
  ];

  constructor(
    private adminService: AdminService,
    private authService: AuthService,
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() { this.loadStats(); }

  loadStats() {
    this.isLoading = true;
    this.loadError = null;

    const safe = <T>(obs: Observable<T>, label: string) =>
      obs.pipe(catchError(() => { console.warn(`stat failed: ${label}`); return of(null); }));

    forkJoin({
      verifications: safe(this.adminService.getPendingVerifications(), 'verifications'),
      applications:  safe(this.adminService.getAdminApplications(), 'applications'),
      offers:        safe(this.adminService.getAdminOffers(), 'offers'),
      users:         safe(this.adminService.getUsers(), 'users'),
    }).subscribe({
      next: (raw) => {
        const v = raw.verifications ? extractAdminPagedResult(raw.verifications) : { items: [], total: 0 };
        this.stats.verifications = v.total;

        const apps = raw.applications ? extractAdminPagedResult(raw.applications) : { items: [], total: 0 };
        this.stats.applications = apps.items.length > 0 ? countPendingApplications(apps.items as unknown[]) : 0;

        const o = raw.offers ? extractAdminPagedResult(raw.offers) : { items: [], total: 0 };
        this.stats.offers = o.total;

        const u = raw.users ? extractAdminPagedResult(raw.users) : { items: [], total: 0 };
        this.stats.users = u.total;

        // Build user rows (first 6)
        this.userRows = (u.items as any[]).slice(0, 6).map((user: any, i: number) => {
          const name = user.name ?? user.Name ?? user.userName ?? user.UserName ?? user.email ?? 'User';
          const roleRaw = (user.role ?? user.Role ?? '').toLowerCase();
          let role: 'admin'|'psw'|'indiv' = 'psw';
          if (roleRaw.includes('admin')) role = 'admin';
          else if (roleRaw.includes('individual') || roleRaw.includes('family')) role = 'indiv';

          return {
            initials: initials(name),
            name,
            email: user.email ?? user.Email ?? '',
            subLabel: user.roleName ?? user.RoleName ?? (role === 'admin' ? 'Super admin' : role === 'psw' ? 'Personal support worker' : 'Family member'),
            role,
            joined: user.createdAt ?? user.CreatedAt ?? '—',
            colorIndex: colorFor(i),
          };
        });

        // Build verification rows
        this.verifRows = (v.items as any[]).slice(0, 3).map((item: any, i: number) => {
          const name = item.name ?? item.Name ?? item.pswName ?? 'Applicant';
          return {
            initials: initials(name),
            name,
            docType: item.documentType ?? item.DocumentType ?? 'Document',
            submittedAgo: '—', // TODO: backend — relative time
            pswId: item.id ?? item.pswId ?? item.userId ?? '',
            colorIndex: colorFor(i),
          };
        });

        // Static activity (TODO: backend — real activity feed)
        this.activityRows = [
          { icon: '✓', tone: 'success', text: '<b>Wellington House</b> approved Amman E.', when: '2m' },
          { icon: '+', tone: 'brand',   text: '<b>Care Home</b> posted a new offer', when: '14m' },
          { icon: '↑', tone: 'info',    text: '<b>Malak M.</b> submitted verification docs', when: '1h' },
          { icon: '!', tone: 'warn',    text: 'Capacity reached at <b>Wellington House</b>', when: '3h' },
        ];

        this.sidebarItems[2].badge = u.total || undefined;
        this.sidebarItems[5].badge = v.total || undefined;

        const anyFailed = Object.values(raw).some((x) => x === null);
        this.loadError = anyFailed ? 'Some statistics could not be loaded.' : null;
        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loadError = 'Could not load dashboard statistics.';
        this.stats = { verifications: 0, applications: 0, offers: 0, users: 0 };
        this.isLoading = false;
        this.cdr.detectChanges();
      },
    });
  }

  onLogout() {
    this.authService.logout();
    this.router.navigate(['/login']);
  }

  rolePillClass(role: string): string {
    if (role === 'admin') return 'role-pill--admin';
    if (role === 'psw')   return 'role-pill--psw';
    return 'role-pill--indiv';
  }

  rolePillLabel(role: string): string {
    if (role === 'admin') return 'Admin';
    if (role === 'psw')   return 'PSW';
    return 'Individual';
  }

  formatDate(val: string): string {
    if (!val || val === '—') return '—';
    try { return new Date(val).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' }); }
    catch { return val; }
  }
}
