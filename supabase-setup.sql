-- =====================================================================
-- J-AUTO 査定システム 履歴用テーブル
-- Supabase の「SQL Editor」に全部貼り付けて「Run」を押す（1回だけ）
-- =====================================================================

-- 1) 査定履歴を入れる表
create table if not exists public.satei_records (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  satei_date  text,          -- 査定日（一覧表示・検索用）
  car_name    text,          -- 車名
  grade       text,          -- グレード
  reg_no      text,          -- 登録No.
  frame_no    text,          -- 車台No.
  odo         text,          -- 走行距離
  staff       text,          -- 査定担当
  data        jsonb not null -- 画面の入力内容すべて（展開図の記号を含む）
);

create index if not exists satei_records_updated_at_idx
  on public.satei_records (updated_at desc);

-- 2) 鍵をかける（ログインしていない人は読めない・書けない）
alter table public.satei_records enable row level security;

drop policy if exists "staff can read"   on public.satei_records;
drop policy if exists "staff can insert" on public.satei_records;
drop policy if exists "staff can update" on public.satei_records;
drop policy if exists "staff can delete" on public.satei_records;

create policy "staff can read"   on public.satei_records
  for select to authenticated using (true);
create policy "staff can insert" on public.satei_records
  for insert to authenticated with check (true);
create policy "staff can update" on public.satei_records
  for update to authenticated using (true) with check (true);
create policy "staff can delete" on public.satei_records
  for delete to authenticated using (true);

-- ログインしていない人（anon）には何も許可しない
revoke all on public.satei_records from anon;
grant select, insert, update, delete on public.satei_records to authenticated;
