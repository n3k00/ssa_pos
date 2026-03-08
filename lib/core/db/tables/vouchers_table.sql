-- Phase 1 offline-first voucher table schema
CREATE TABLE IF NOT EXISTS vouchers (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  date_and_time TEXT NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'payment_due',
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  facebook_account TEXT,
  parcel_number TEXT NOT NULL,
  note TEXT,
  item_image_path TEXT,
  dispatch_receipt_image_path TEXT
);

CREATE INDEX IF NOT EXISTS idx_vouchers_created_at ON vouchers(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_vouchers_phone ON vouchers(phone);
CREATE INDEX IF NOT EXISTS idx_vouchers_parcel_number ON vouchers(parcel_number);
CREATE INDEX IF NOT EXISTS idx_vouchers_name ON vouchers(name);
