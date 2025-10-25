# UntitledUI Integration Guide

**Date:** 2025-10-25
**Purpose:** How components work together - composition strategies, dependency management, integration patterns
**Critical Lesson:** Components are designed to compose, not exist in isolation

---

## Table of Contents

1. [Integration Principles](#integration-principles)
2. [Dependency Architecture](#dependency-architecture)
3. [Composition Strategies](#composition-strategies)
4. [Common Integration Patterns](#common-integration-patterns)
5. [Category-Specific Integration](#category-specific-integration)
6. [Integration Anti-Patterns](#integration-anti-patterns)
7. [Real-World Integration Examples](#real-world-integration-examples)
8. [Integration Checklist](#integration-checklist)

---

## Integration Principles

### Core Integration Rules

1. **Unidirectional Dependencies** - Components depend down the hierarchy, never up

```
application/ components
    ↓ may depend on
base/ components
    ↓ may depend on
foundations/ + React Aria + Design Tokens
    ↓ no component dependencies
```

2. **No Circular Dependencies** - base/ components do NOT depend on each other

```
✅ CORRECT:
Table (application/) → uses Button (base/)
Button (base/) → uses design tokens

❌ WRONG:
Button (base/) → uses Input (base/)  // Circular in same category
```

3. **Composition Over Configuration** - Components compose via children, not complex prop APIs

```typescript
// ✅ CORRECT - Composition
<Card>
  <Card.Header title="User Profile" />
  <Card.Body>
    <Avatar src={user.avatar} />
    <p>{user.name}</p>
  </Card.Body>
</Card>

// ❌ WRONG - Configuration
<Card
  headerTitle="User Profile"
  avatar={user.avatar}
  userName={user.name}
  bodyContent={/* ... */}
/>
```

4. **Explicit Over Implicit** - Integration points are visible in code, not hidden

```typescript
// ✅ CORRECT - Explicit integration
<Table>
  <Table.Row>
    <Table.Cell>
      <Checkbox checked={selected} />
    </Table.Cell>
    <Table.Cell>{user.name}</Table.Cell>
  </Table.Row>
</Table>

// ❌ WRONG - Implicit integration
<Table selectable data={users} />
// Where does Checkbox come from? Hidden magic.
```

---

## Dependency Architecture

### Component Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│ Next.js Pages (Marketing Compositions)                  │
│ - Landing pages                                         │
│ - Marketing pages                                       │
└─────────────────────────────────────────────────────────┘
                           ↓ composes
┌─────────────────────────────────────────────────────────┐
│ application/ Components                                 │
│ - Modals, Tables, Navigation                           │
│ - Charts, Tabs, Pagination                             │
│ - File Upload, Date Pickers                            │
└─────────────────────────────────────────────────────────┘
                           ↓ composes
┌─────────────────────────────────────────────────────────┐
│ base/ Components                                        │
│ - Buttons, Inputs, Toggles                             │
│ - Badges, Avatars, Tooltips                            │
│ - Checkboxes, Select, Radio                            │
└─────────────────────────────────────────────────────────┘
                           ↓ uses
┌─────────────────────────────────────────────────────────┐
│ foundations/ + React Aria + Design Tokens              │
│ - Icons, Colors, Typography                            │
│ - Accessibility primitives                             │
│ - Theme configuration                                   │
└─────────────────────────────────────────────────────────┘
```

### Dependency Rules by Category

**base/ components:**

- ✅ MAY use: foundations/, React Aria, design tokens
- ❌ MAY NOT use: Other base/ components, application/ components

**application/ components:**

- ✅ MAY use: base/ components, foundations/, React Aria, design tokens
- ❌ MAY NOT use: Other application/ components (except specific cases)

**foundations/:**

- ✅ MAY use: Design tokens only
- ❌ MAY NOT use: Any components

**Marketing pages (Next.js):**

- ✅ MAY use: application/ components, base/ components, foundations/
- ❌ MAY NOT use: Internal utilities

### Dependency Examples

**Table Component (application/) Dependencies:**

```typescript
// table.tsx (application/)

// ✅ Imports from base/
import { Checkbox } from '@/components/base/checkbox';
import { Dropdown } from '@/components/base/dropdown';
import { Badge } from '@/components/base/badges';
import { Tooltip } from '@/components/base/tooltip';
import { Button } from '@/components/base/buttons';

// ✅ Imports from foundations/
import { cx } from '@/utils/cx';

// ✅ Imports from React Aria
import { Table as AriaTable, TableHeader, TableBody } from 'react-aria-components';

// ❌ CANNOT import from other application/
// import { Modal } from '@/components/application/modals';  // WRONG
```

**Button Component (base/) Dependencies:**

```typescript
// button.tsx (base/)

// ✅ Imports from foundations/
import { cx } from '@/utils/cx';

// ✅ Imports from React Aria
import { Button as AriaButton } from 'react-aria-components';

// ❌ CANNOT import other base/ components
// import { Badge } from '@/components/base/badges';  // WRONG

// ❌ CANNOT import application/ components
// import { Table } from '@/components/application/table';  // WRONG
```

---

## Composition Strategies

### Strategy 1: Dot Notation Composition (Most Common)

**When to Use:** Component has clear parent-child relationship

**Pattern:**

```typescript
// Parent component
export function Table({ children }: TableProps) {
  return <table>{children}</table>;
}

// Attach sub-components
Table.Header = function TableHeader({ children }: TableHeaderProps) {
  return <thead>{children}</thead>;
};

Table.Body = function TableBody({ children }: TableBodyProps) {
  return <tbody>{children}</tbody>;
};

Table.Row = function TableRow({ children }: TableRowProps) {
  return <tr>{children}</tr>;
};

Table.Cell = function TableCell({ children }: TableCellProps) {
  return <td>{children}</td>;
};

// Usage
<Table>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>Name</Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell>John Doe</Table.Cell>
    </Table.Row>
  </Table.Body>
</Table>
```

**Benefits:**

- Clear namespace (Table.Row vs just Row)
- Editor autocomplete shows available sub-components
- Sub-components only make sense within parent

**Components Using This:**

- Table (Table.Header, Table.Row, Table.Cell)
- Card (Card.Header, Card.Body, Card.Footer)
- Modal (Modal.Header, Modal.Body, Modal.Footer)
- Tabs (Tabs.List, Tabs.Tab, Tabs.Panel)

---

### Strategy 2: Children Composition (Maximum Flexibility)

**When to Use:** Component accepts any valid React children

**Pattern:**

```typescript
export function Card({ children, className }: CardProps) {
  return (
    <div className={cx('card', className)}>
      {children}
    </div>
  );
}

// Usage - Total flexibility
<Card>
  <h2>Card Title</h2>
  <p>Card description</p>
  <Button>Action</Button>
  <Badge>New</Badge>
</Card>
```

**Benefits:**

- Maximum flexibility
- No structure enforcement
- Easy to customize

**Drawbacks:**

- No structure guidance
- Easy to misuse

**Components Using This:**

- Card (basic version)
- Container layouts
- Modal body sections

---

### Strategy 3: Context-Based Integration (State Sharing)

**When to Use:** Sub-components need to share state with parent

**Pattern:**

```typescript
// tabs.tsx

const TabsContext = createContext<TabsContextValue | null>(null);

export function Tabs({ defaultTab, children }: TabsProps) {
  const [selectedTab, setSelectedTab] = useState(defaultTab);

  return (
    <TabsContext.Provider value={{ selectedTab, setSelectedTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  );
}

Tabs.List = function TabsList({ children }: TabsListProps) {
  return <div className="tabs-list">{children}</div>;
};

Tabs.Tab = function Tab({ value, children }: TabProps) {
  const { selectedTab, setSelectedTab } = useContext(TabsContext)!;

  return (
    <button
      className={cx('tab', selectedTab === value && 'active')}
      onClick={() => setSelectedTab(value)}
    >
      {children}
    </button>
  );
};

Tabs.Panel = function TabPanel({ value, children }: TabPanelProps) {
  const { selectedTab } = useContext(TabsContext)!;
  if (selectedTab !== value) return null;
  return <div className="tab-panel">{children}</div>;
};

// Usage
<Tabs defaultTab="profile">
  <Tabs.List>
    <Tabs.Tab value="profile">Profile</Tabs.Tab>
    <Tabs.Tab value="settings">Settings</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel value="profile">Profile content</Tabs.Panel>
  <Tabs.Panel value="settings">Settings content</Tabs.Panel>
</Tabs>
```

**Benefits:**

- State automatically shared
- No manual prop threading
- Clean API

**Components Using This:**

- Tabs (selected tab state)
- RadioGroup (selected value)
- Select (selected option)
- ButtonGroup (group state)

---

### Strategy 4: Render Props (Advanced Control)

**When to Use:** Consumer needs control over rendering

**Pattern:**

```typescript
export interface SelectProps<T> {
  options: T[];
  value: T;
  onChange: (value: T) => void;
  renderOption?: (option: T) => React.ReactNode;
  renderValue?: (value: T) => React.ReactNode;
}

export function Select<T>({
  options,
  value,
  onChange,
  renderOption,
  renderValue,
}: SelectProps<T>) {
  return (
    <AriaSelect value={value} onChange={onChange}>
      <Button>
        {renderValue ? renderValue(value) : String(value)}
      </Button>
      <Popover>
        <ListBox>
          {options.map(option => (
            <ListBoxItem key={String(option)}>
              {renderOption ? renderOption(option) : String(option)}
            </ListBoxItem>
          ))}
        </ListBox>
      </Popover>
    </AriaSelect>
  );
}

// Usage - Custom rendering
<Select
  options={users}
  value={selectedUser}
  onChange={setSelectedUser}
  renderOption={(user) => (
    <div className="user-option">
      <Avatar src={user.avatar} size="sm" />
      <span>{user.name}</span>
      <Badge>{user.role}</Badge>
    </div>
  )}
  renderValue={(user) => (
    <div className="selected-user">
      <Avatar src={user.avatar} size="xs" />
      <span>{user.name}</span>
    </div>
  )}
/>
```

**Benefits:**

- Maximum customization
- Type-safe rendering
- Flexible presentation

**Components Using This:**

- Select (option rendering)
- Table (cell rendering)
- List (item rendering)

---

## Common Integration Patterns

### Pattern 1: Form Integration

**Components:** Input + Button + Form

```typescript
<Form onSubmit={handleSubmit}>
  <Input
    label="Email"
    name="email"
    type="email"
    required
    hint="We'll never share your email"
  />

  <Input
    label="Password"
    name="password"
    type="password"
    required
  />

  <div className="form-actions">
    <Button type="submit" variant="primary">
      Sign In
    </Button>
    <Button type="button" variant="secondary" href="/forgot-password">
      Forgot Password?
    </Button>
  </div>
</Form>
```

**Integration Points:**

- Form validates inputs on submit
- Button type="submit" triggers form submission
- Input components auto-associate with Form
- Validation errors displayed per-input

---

### Pattern 2: Table with Selection

**Components:** Table + Checkbox + Badge + Dropdown + Tooltip

```typescript
<Table>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>
        <Checkbox
          checked={allSelected}
          onChange={handleSelectAll}
          aria-label="Select all rows"
        />
      </Table.HeaderCell>
      <Table.HeaderCell>User</Table.HeaderCell>
      <Table.HeaderCell>Status</Table.HeaderCell>
      <Table.HeaderCell>Actions</Table.HeaderCell>
    </Table.Row>
  </Table.Header>

  <Table.Body>
    {users.map(user => (
      <Table.Row key={user.id}>
        <Table.Cell>
          <Checkbox
            checked={selected.includes(user.id)}
            onChange={() => handleSelect(user.id)}
            aria-label={`Select ${user.name}`}
          />
        </Table.Cell>

        <Table.Cell>
          <div className="flex items-center gap-2">
            <Avatar src={user.avatar} size="sm" />
            <div>
              <p className="font-medium">{user.name}</p>
              <p className="text-sm text-fg-quaternary">{user.email}</p>
            </div>
          </div>
        </Table.Cell>

        <Table.Cell>
          <Badge variant={user.status === 'active' ? 'success' : 'gray'}>
            {user.status}
          </Badge>
        </Table.Cell>

        <Table.Cell>
          <Dropdown>
            <Dropdown.Trigger>
              <Button variant="tertiary" size="sm">
                Actions
              </Button>
            </Dropdown.Trigger>
            <Dropdown.Menu>
              <Dropdown.Item onAction={() => handleEdit(user)}>
                Edit
              </Dropdown.Item>
              <Dropdown.Item onAction={() => handleDelete(user)}>
                Delete
              </Dropdown.Item>
            </Dropdown.Menu>
          </Dropdown>
        </Table.Cell>
      </Table.Row>
    ))}
  </Table.Body>
</Table>
```

**Integration Points:**

- Table provides structure
- Checkbox manages selection state
- Avatar shows user visual
- Badge displays status with color
- Dropdown provides row actions

---

### Pattern 3: Modal with Form

**Components:** Modal + Form + Input + Button

```typescript
<Modal isOpen={showModal} onClose={closeModal}>
  <Modal.Header>
    <Modal.Title>Create New User</Modal.Title>
    <Modal.CloseButton />
  </Modal.Header>

  <Modal.Body>
    <Form onSubmit={handleCreate}>
      <Input
        label="Full Name"
        name="name"
        required
      />

      <Input
        label="Email"
        name="email"
        type="email"
        required
      />

      <Select
        label="Role"
        name="role"
        options={roles}
      />
    </Form>
  </Modal.Body>

  <Modal.Footer>
    <Button variant="secondary" onClick={closeModal}>
      Cancel
    </Button>
    <Button variant="primary" type="submit">
      Create User
    </Button>
  </Modal.Footer>
</Modal>
```

**Integration Points:**

- Modal manages open/close state
- Form handles validation
- Inputs integrate with Form
- Buttons trigger modal actions
- Modal.CloseButton integrates with Modal state

---

### Pattern 4: Navigation with Badges

**Components:** Navigation + Badge + Avatar + Dropdown

```typescript
<AppNavigation>
  <AppNavigation.Logo href="/">
    <Logo />
  </AppNavigation.Logo>

  <AppNavigation.Menu>
    <AppNavigation.Item href="/dashboard">
      Dashboard
    </AppNavigation.Item>

    <AppNavigation.Item href="/messages">
      Messages
      <Badge variant="error" size="sm">3</Badge>
    </AppNavigation.Item>

    <AppNavigation.Item href="/notifications">
      Notifications
      <Badge variant="primary" size="sm">12</Badge>
    </AppNavigation.Item>
  </AppNavigation.Menu>

  <AppNavigation.Actions>
    <Dropdown>
      <Dropdown.Trigger>
        <Avatar src={user.avatar} size="sm" />
      </Dropdown.Trigger>
      <Dropdown.Menu>
        <Dropdown.Item href="/profile">Profile</Dropdown.Item>
        <Dropdown.Item href="/settings">Settings</Dropdown.Item>
        <Dropdown.Divider />
        <Dropdown.Item onAction={handleLogout}>
          Logout
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  </AppNavigation.Actions>
</AppNavigation>
```

**Integration Points:**

- Navigation provides structure
- Badge shows notification counts
- Avatar triggers user menu
- Dropdown provides user actions

---

### Pattern 5: Empty State with Actions

**Components:** EmptyState + Button + Avatar (illustration)

```typescript
<EmptyState>
  <EmptyState.Icon>
    <Avatar size="xl" />
  </EmptyState.Icon>

  <EmptyState.Title>
    No users found
  </EmptyState.Title>

  <EmptyState.Description>
    Get started by creating a new user account.
  </EmptyState.Description>

  <EmptyState.Actions>
    <Button variant="primary" iconBefore={<PlusIcon />}>
      Create User
    </Button>
    <Button variant="secondary" href="/import">
      Import Users
    </Button>
  </EmptyState.Actions>
</EmptyState>
```

**Integration Points:**

- EmptyState provides layout
- Buttons provide primary/secondary actions
- Icons illustrate empty state

---

## Category-Specific Integration

### base/ Components Integration

**Rule:** base/ components do NOT integrate with each other directly.

**Example - Button does NOT integrate Input:**

```typescript
// ❌ WRONG - base/ component importing another base/
// button.tsx
import { Input } from '@/components/base/input';  // NO!

export function Button({ ...props }) {
  // Cannot use Input here
}

// ✅ CORRECT - application/ component integrates base/
// form.tsx (application/)
import { Button } from '@/components/base/buttons';
import { Input } from '@/components/base/input';

export function Form({ children }) {
  return (
    <form>
      {children}  // Composition - Input and Button composed by consumer
    </form>
  );
}
```

**Why:** Prevents circular dependencies and maintains clear hierarchy.

---

### application/ Components Integration

**Rule:** application/ components integrate base/ components freely.

**Example - Table integrates multiple base/ components:**

```typescript
// table.tsx (application/)
import { Checkbox } from '@/components/base/checkbox';
import { Dropdown } from '@/components/base/dropdown';
import { Badge } from '@/components/base/badges';
import { Tooltip } from '@/components/base/tooltip';
import { Button } from '@/components/base/buttons';
import { Avatar } from '@/components/base/avatar';

export function Table({ children, selectable, ...props }: TableProps) {
  // Can integrate all base/ components
  return (
    <table {...props}>
      {children}
    </table>
  );
}

Table.Cell = function TableCell({ children }: TableCellProps) {
  // Can render any base/ component as children
  return <td>{children}</td>;
};
```

**Integration Graph for Table:**

```
Table (application/)
├── uses Checkbox (base/)
├── uses Dropdown (base/)
├── uses Badge (base/)
├── uses Tooltip (base/)
├── uses Button (base/)
└── uses Avatar (base/)
```

---

### Marketing Pages Integration

**Rule:** Marketing pages compose application/ and base/ components.

**Example - Landing Page Hero:**

```typescript
// app/page.tsx (Next.js)

import { HeaderSection } from '@/components/marketing/header-sections';
import { Button } from '@/components/base/buttons';
import { Badge } from '@/components/base/badges';
import { Input } from '@/components/base/input';

export default function LandingPage() {
  return (
    <>
      <HeaderSection variant="hero-with-image">
        <HeaderSection.Badge>
          <Badge variant="primary">New Feature</Badge>
        </HeaderSection.Badge>

        <HeaderSection.Title>
          Build better products faster
        </HeaderSection.Title>

        <HeaderSection.Description>
          The all-in-one platform for modern product teams
        </HeaderSection.Description>

        <HeaderSection.Actions>
          <Button variant="primary" size="lg">
            Get Started
          </Button>
          <Button variant="secondary" size="lg" href="/demo">
            Watch Demo
          </Button>
        </HeaderSection.Actions>

        <HeaderSection.Form>
          <Input placeholder="Enter your email" type="email" />
          <Button variant="primary">Subscribe</Button>
        </HeaderSection.Form>
      </HeaderSection>
    </>
  );
}
```

**Integration Graph:**

```
Landing Page (Next.js)
└── uses HeaderSection (marketing/)
    ├── uses Badge (base/)
    ├── uses Button (base/)
    └── uses Input (base/)
```

---

## Integration Anti-Patterns

### Anti-Pattern 1: Circular Dependencies ❌

**Problem:** base/ components depend on each other.

```typescript
// ❌ WRONG - Circular dependency

// button.tsx (base/)
import { Badge } from './badges';  // base/ → base/

export function Button({ badge, children }) {
  return (
    <button>
      {children}
      {badge && <Badge>{badge}</Badge>}
    </button>
  );
}

// badge.tsx (base/)
import { Button } from './buttons';  // base/ → base/

export function Badge({ dismissible, onDismiss }) {
  return (
    <span>
      Badge
      {dismissible && <Button onClick={onDismiss}>×</Button>}
    </span>
  );
}
```

**Solution:** Composition by consumer

```typescript
// ✅ CORRECT - Consumer composes

// button.tsx (base/)
export function Button({ children }) {
  return <button>{children}</button>;
}

// badge.tsx (base/)
export function Badge({ children }) {
  return <span className="badge">{children}</span>;
}

// Usage (application/ or page level)
<Button>
  Save
  <Badge>New</Badge>
</Button>
```

---

### Anti-Pattern 2: Prop Drilling Integration ❌

**Problem:** Passing component instances through many prop layers.

```typescript
// ❌ WRONG - Prop drilling

<Table
  headerCheckbox={<Checkbox />}
  rowCheckbox={<Checkbox />}
  rowBadge={<Badge />}
  rowDropdown={<Dropdown />}
  cellAvatar={<Avatar />}
>
  {/* Deep prop passing */}
</Table>
```

**Solution:** Composition via children

```typescript
// ✅ CORRECT - Direct composition

<Table>
  <Table.Header>
    <Table.Row>
      <Table.HeaderCell>
        <Checkbox />
      </Table.HeaderCell>
    </Table.Row>
  </Table.Header>
  <Table.Body>
    <Table.Row>
      <Table.Cell><Checkbox /></Table.Cell>
      <Table.Cell><Avatar /></Table.Cell>
      <Table.Cell><Badge /></Table.Cell>
    </Table.Row>
  </Table.Body>
</Table>
```

---

### Anti-Pattern 3: Hidden Integration ❌

**Problem:** Component internally uses other components invisibly.

```typescript
// ❌ WRONG - Hidden integration

export function UserCard({ user, selectable }: UserCardProps) {
  return (
    <div className="user-card">
      {/* Hidden Checkbox - where did it come from? */}
      {selectable && <Checkbox />}

      {/* Hidden Avatar */}
      <Avatar src={user.avatar} />

      {/* Hidden Badge */}
      <Badge>{user.status}</Badge>
    </div>
  );
}

// Usage - not obvious what components are used
<UserCard user={user} selectable />
```

**Solution:** Explicit composition

```typescript
// ✅ CORRECT - Explicit integration

export function UserCard({ children }: UserCardProps) {
  return <div className="user-card">{children}</div>;
}

// Usage - crystal clear what's integrated
<UserCard>
  <Checkbox />
  <Avatar src={user.avatar} />
  <Badge>{user.status}</Badge>
</UserCard>
```

---

### Anti-Pattern 4: Over-Abstraction ❌

**Problem:** Creating wrapper components that hide too much.

```typescript
// ❌ WRONG - Over-abstracted

export function TableWithEverything({ data, onEdit, onDelete }: TableProps) {
  return (
    <Table>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell><Checkbox /></Table.HeaderCell>
          <Table.HeaderCell>Name</Table.HeaderCell>
          <Table.HeaderCell>Actions</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {data.map(item => (
          <Table.Row key={item.id}>
            <Table.Cell><Checkbox /></Table.Cell>
            <Table.Cell>{item.name}</Table.Cell>
            <Table.Cell>
              <Dropdown>
                <Dropdown.Item onAction={() => onEdit(item)}>Edit</Dropdown.Item>
                <Dropdown.Item onAction={() => onDelete(item)}>Delete</Dropdown.Item>
              </Dropdown>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

// Usage - too magical, hard to customize
<TableWithEverything data={users} onEdit={handleEdit} onDelete={handleDelete} />
```

**Solution:** Explicit composition with patterns

```typescript
// ✅ CORRECT - Composition with shared patterns

export function UsersTable({ users, onEdit, onDelete }: UsersTableProps) {
  return (
    <Table>
      <Table.Header>
        <Table.Row>
          <Table.HeaderCell><Checkbox /></Table.HeaderCell>
          <Table.HeaderCell>Name</Table.HeaderCell>
          <Table.HeaderCell>Actions</Table.HeaderCell>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {users.map(user => (
          <Table.Row key={user.id}>
            <Table.Cell><Checkbox /></Table.Cell>
            <Table.Cell>{user.name}</Table.Cell>
            <Table.Cell>
              <UserActions user={user} onEdit={onEdit} onDelete={onDelete} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table.Body>
    </Table>
  );
}

function UserActions({ user, onEdit, onDelete }) {
  return (
    <Dropdown>
      <Dropdown.Item onAction={() => onEdit(user)}>Edit</Dropdown.Item>
      <Dropdown.Item onAction={() => onDelete(user)}>Delete</Dropdown.Item>
    </Dropdown>
  );
}
```

---

## Real-World Integration Examples

### Example 1: User Management Dashboard

**Components:** Table + Avatar + Badge + Button + Dropdown + Checkbox + Modal + Form + Input

```typescript
export function UserManagementDashboard() {
  const [users, setUsers] = useState<User[]>([]);
  const [selected, setSelected] = useState<string[]>([]);
  const [showModal, setShowModal] = useState(false);

  return (
    <div>
      {/* Header with Actions */}
      <div className="header">
        <h1>Users</h1>
        <div className="actions">
          <Button variant="primary" onClick={() => setShowModal(true)}>
            Create User
          </Button>
          {selected.length > 0 && (
            <Button variant="secondary-destructive" onClick={handleBulkDelete}>
              Delete Selected ({selected.length})
            </Button>
          )}
        </div>
      </div>

      {/* Users Table */}
      <Table>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>
              <Checkbox
                checked={selected.length === users.length}
                onChange={handleSelectAll}
              />
            </Table.HeaderCell>
            <Table.HeaderCell>User</Table.HeaderCell>
            <Table.HeaderCell>Role</Table.HeaderCell>
            <Table.HeaderCell>Status</Table.HeaderCell>
            <Table.HeaderCell>Actions</Table.HeaderCell>
          </Table.Row>
        </Table.Header>

        <Table.Body>
          {users.map(user => (
            <Table.Row key={user.id}>
              <Table.Cell>
                <Checkbox
                  checked={selected.includes(user.id)}
                  onChange={() => handleToggleSelect(user.id)}
                />
              </Table.Cell>

              <Table.Cell>
                <div className="flex items-center gap-3">
                  <Avatar src={user.avatar} size="sm" />
                  <div>
                    <p className="font-medium">{user.name}</p>
                    <p className="text-sm text-fg-quaternary">{user.email}</p>
                  </div>
                </div>
              </Table.Cell>

              <Table.Cell>
                <Badge variant="gray">{user.role}</Badge>
              </Table.Cell>

              <Table.Cell>
                <Badge variant={user.active ? 'success' : 'error'}>
                  {user.active ? 'Active' : 'Inactive'}
                </Badge>
              </Table.Cell>

              <Table.Cell>
                <Dropdown>
                  <Dropdown.Trigger>
                    <Button variant="tertiary" size="sm">
                      Actions
                    </Button>
                  </Dropdown.Trigger>
                  <Dropdown.Menu>
                    <Dropdown.Item onAction={() => handleEdit(user)}>
                      Edit
                    </Dropdown.Item>
                    <Dropdown.Item onAction={() => handleResetPassword(user)}>
                      Reset Password
                    </Dropdown.Item>
                    <Dropdown.Divider />
                    <Dropdown.Item onAction={() => handleDelete(user)}>
                      Delete
                    </Dropdown.Item>
                  </Dropdown.Menu>
                </Dropdown>
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>

      {/* Create User Modal */}
      <Modal isOpen={showModal} onClose={() => setShowModal(false)}>
        <Modal.Header>
          <Modal.Title>Create New User</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <Form onSubmit={handleCreateUser}>
            <Input label="Full Name" name="name" required />
            <Input label="Email" name="email" type="email" required />
            <Select label="Role" name="role" options={roles} />
          </Form>
        </Modal.Body>

        <Modal.Footer>
          <Button variant="secondary" onClick={() => setShowModal(false)}>
            Cancel
          </Button>
          <Button variant="primary" type="submit">
            Create User
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}
```

**Integration Points:**

1. Table provides data structure
2. Checkbox manages row selection
3. Avatar displays user photo
4. Badge shows role and status
5. Dropdown provides row actions
6. Modal contains creation form
7. Form validates inputs
8. Button triggers actions

---

## Integration Checklist

### Before Integrating Components

- [ ] **Check dependency rules** - Does this follow hierarchy?
- [ ] **Verify no circular dependencies** - base/ not depending on base/?
- [ ] **Choose composition strategy** - Dot notation, children, context, or render props?
- [ ] **Plan integration points** - Where do components connect?
- [ ] **Document integration** - Clear examples in .patterns.md file

### During Integration

- [ ] **Explicit over implicit** - Integration visible in code
- [ ] **Type-safe integration** - TypeScript validates composition
- [ ] **Accessibility maintained** - ARIA relationships preserved
- [ ] **Responsive behavior** - Components work together at all sizes

### After Integration

- [ ] **Test composition** - Does integration work correctly?
- [ ] **Check accessibility** - Screen reader announces correctly?
- [ ] **Validate performance** - No unnecessary re-renders?
- [ ] **Document pattern** - Add to integration examples

---

## Summary

### Key Integration Principles

1. **Unidirectional Dependencies** - application/ → base/ → foundations/
2. **No Circular Dependencies** - base/ never depends on base/
3. **Composition Over Configuration** - Children composition preferred
4. **Explicit Over Implicit** - Integration points visible

### Composition Strategies

1. **Dot Notation** - Component.SubComponent (most common)
2. **Children** - Maximum flexibility
3. **Context** - State sharing between sub-components
4. **Render Props** - Custom rendering control

### Common Patterns

1. **Form Integration** - Input + Button + Form
2. **Table with Selection** - Table + Checkbox + Badge + Dropdown
3. **Modal with Form** - Modal + Form + Input + Button
4. **Navigation** - Navigation + Badge + Avatar + Dropdown
5. **Empty State** - EmptyState + Button + Icon

### Anti-Patterns to Avoid

1. ❌ Circular dependencies (base/ → base/)
2. ❌ Prop drilling integration
3. ❌ Hidden integration (components used invisibly)
4. ❌ Over-abstraction (too much magic)

---

**Document Status:** Phase 0.5 Complete (5 of 6 master documents)

**Next:** REFERENCE-STUDY-GUIDE.md - How to use UPSTREAM/ and untitledui.com together

**See Also:**

- SYSTEM-ARCHITECTURE.md - Overall architecture and dependencies
- PATTERN-LIBRARY.md - Patterns with scope labels
- COMPONENT-TAXONOMY.md - Component categories
