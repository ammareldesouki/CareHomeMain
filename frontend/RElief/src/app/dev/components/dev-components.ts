import { Component, ChangeDetectionStrategy } from '@angular/core';
import { ButtonComponent } from '../../shared/ui/button/button';
import { PillComponent } from '../../shared/ui/pill/pill';
import { AvatarComponent } from '../../shared/ui/avatar/avatar';
import { CardComponent } from '../../shared/layout/card/card';
import { StatCardComponent } from '../../shared/layout/stat-card/stat-card';
import { TabsComponent } from '../../shared/layout/tabs/tabs';
import { BreadcrumbComponent } from '../../shared/layout/breadcrumb/breadcrumb';
import { EmptyStateComponent } from '../../shared/layout/empty-state/empty-state';
import { AlertComponent } from '../../shared/layout/alert/alert';
import { SidebarComponent, SidebarItem } from '../../shared/components/sidebar/sidebar';
import { TableComponent, TableColumn } from '../../shared/components/table/table';
import { ModalComponent } from '../../shared/components/modal/modal.component';
import { OfferCardComponent } from '../../shared/components/offer-card/offer-card';

@Component({
  selector: 'app-dev-components',
  standalone: true,
  imports: [
    ButtonComponent, PillComponent, AvatarComponent,
    CardComponent, StatCardComponent, TabsComponent,
    BreadcrumbComponent, EmptyStateComponent, AlertComponent,
    SidebarComponent, TableComponent, ModalComponent, OfferCardComponent
  ],
  templateUrl: './dev-components.html',
  styleUrls: ['./dev-components.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class DevComponentsComponent {
  breadcrumbItems = [
    { label: 'Workspace', path: '/care-home' },
    { label: 'Offers', path: '/care-home' },
    { label: 'PSW needed' }
  ];

  sidebarItems: SidebarItem[] = [
    { type: 'section', label: 'Workspace' },
    { type: 'link', label: 'Dashboard', icon: '⌂', path: '/care-home' },
    { type: 'link', label: 'Offers', icon: '≡', path: '/care-home/history', badge: 12 },
    { type: 'link', label: 'Applications', icon: '⏱', path: '/care-home/notifications', badge: 2 },
    { type: 'section', label: 'Account' },
    { type: 'link', label: 'Profile', icon: '☺', path: '/care-home/profile' },
  ];

  tableColumns: TableColumn[] = [
    { key: 'name', header: 'Applicant', type: 'avatar-text', subKey: 'email' },
    { key: 'offer', header: 'Offer', type: 'text' },
    { key: 'shift', header: 'Shift', type: 'text' },
    { key: 'status', header: 'Status', type: 'pill', pillMap: { Pending: 'warn', Approved: 'success', Rejected: 'danger' } },
    { key: '_actions', header: '', type: 'actions', actions: [
      { label: '✓ Approve', event: 'approve', variant: 'success' },
      { label: 'Reject', event: 'reject', variant: 'secondary' }
    ]}
  ];

  tableRows = [
    { name: 'Amman Eldesouki', email: 'omarpsw@gmail.com', offer: 'Personal support worker', shift: 'May 29 · 09:00–17:00', status: 'Pending' },
    { name: 'Malak Mohamed', email: 'malakm@gmail.com', offer: 'Nurse — overnight', shift: 'May 4 · 08:00–16:00', status: 'Approved' },
    { name: 'Nourhan Mohamed', email: 'nourhan@gmail.com', offer: 'PSW needed', shift: 'May 21 · 09:00–17:00', status: 'Rejected' },
  ];

  modalOpen = false;
}
