-- Auto-generated idempotent catalog seed: 12 main categories, 36 subcategories, 263 products, shop coupons.
-- Safe to re-run: preserves existing products' stock_qty while enriching metadata, writes INITIAL stock_movements for new items.
begin;

-- 1. Upsert 12 main categories
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Food & Drinks', 'อาหารและเครื่องดื่ม', 'food-drinks', '🍜', 10, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Home & Living', 'ของใช้ในบ้าน', 'home-living', '🏠', 20, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Electronics', 'อิเล็กทรอนิกส์', 'electronics', '📱', 30, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Hardware & Tools', 'เครื่องมือช่าง', 'hardware-tools', '🔧', 40, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Beauty', 'ความงามและดูแลผิว', 'beauty', '✨', 50, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Fashion', 'แฟชั่นและกระเป๋า', 'fashion', '👜', 60, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Sports', 'กีฬาและเอาท์ดอร์', 'sports', '🏃', 70, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Pet Care', 'สัตว์เลี้ยง', 'pet-care', '🐾', 80, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Health & Wellness', 'สุขภาพและอาหารเสริม', 'health-wellness', '💊', 90, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Mom & Baby', 'แม่และเด็ก', 'mom-baby', '🍼', 100, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Office & Stationery', 'เครื่องเขียนและสำนักงาน', 'office-stationery', '📎', 110, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Garden & Auto', 'สวนและยานยนต์', 'garden-auto', '🌿', 120, null) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = null;

-- 2. Upsert 36 subcategories linked to parent categories
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Pantry & Condiments', 'เครื่องปรุงและของแห้ง', 'pantry-condiments', '🧂', 101, (select category_id from public.categories where name = 'Food & Drinks')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Beverages', 'เครื่องดื่มและกาแฟ', 'beverages', '☕', 102, (select category_id from public.categories where name = 'Food & Drinks')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Snacks & Bakery', 'ขนมและของว่าง', 'snacks-bakery', '🍪', 103, (select category_id from public.categories where name = 'Food & Drinks')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Kitchen & Dining', 'ครัวและโต๊ะอาหาร', 'kitchen-dining', '🍳', 201, (select category_id from public.categories where name = 'Home & Living')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Bedding & Decor', 'เครื่องนอนและของแต่งบ้าน', 'bedding-decor', '🛋️', 202, (select category_id from public.categories where name = 'Home & Living')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Cleaning & Laundry', 'ทำความสะอาดและซักรีด', 'cleaning-laundry', '🫧', 203, (select category_id from public.categories where name = 'Home & Living')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Chargers & Accessories', 'สายชาร์จและอุปกรณ์เสริม', 'chargers-accessories', '🔌', 301, (select category_id from public.categories where name = 'Electronics')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Audio & Wearables', 'หูฟังและแกดเจ็ต', 'audio-wearables', '🎧', 302, (select category_id from public.categories where name = 'Electronics')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Computer & Smart Home', 'คอมพิวเตอร์และสมาร์ทโฮม', 'computer-smart-home', '⌨️', 303, (select category_id from public.categories where name = 'Electronics')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Power Tools', 'เครื่องมือไฟฟ้า', 'power-tools', '⚡', 401, (select category_id from public.categories where name = 'Hardware & Tools')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Hand Tools', 'เครื่องมือช่างทั่วไป', 'hand-tools', '🛠️', 402, (select category_id from public.categories where name = 'Hardware & Tools')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Electrical & Plumbing', 'อุปกรณ์ไฟฟ้าและประปา', 'electrical-plumbing', '💡', 403, (select category_id from public.categories where name = 'Hardware & Tools')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Skincare', 'บำรุงผิวหน้า', 'skincare', '🧴', 501, (select category_id from public.categories where name = 'Beauty')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Hair & Body Care', 'ดูแลผมและผิวกาย', 'hair-body-care', '🧼', 502, (select category_id from public.categories where name = 'Beauty')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Fragrance & Aroma', 'น้ำหอมและอโรมา', 'fragrance-aroma', '🕯️', 503, (select category_id from public.categories where name = 'Beauty')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Bags & Accessories', 'กระเป๋าและแอคเซสซอรี', 'bags-accessories', '🎒', 601, (select category_id from public.categories where name = 'Fashion')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Apparel', 'เสื้อผ้าและเครื่องแต่งกาย', 'apparel', '👕', 602, (select category_id from public.categories where name = 'Fashion')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Footwear', 'รองเท้า', 'footwear', '👟', 603, (select category_id from public.categories where name = 'Fashion')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Fitness & Yoga', 'ฟิตเนสและโยคะ', 'fitness-yoga', '🏋️', 701, (select category_id from public.categories where name = 'Sports')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Bottles & Hydration', 'ขวดน้ำและแก้วเก็บความเย็น', 'bottles-hydration', '🥤', 702, (select category_id from public.categories where name = 'Sports')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Camping & Outdoor', 'แคมป์ปิ้งและเดินป่า', 'camping-outdoor', '⛺', 703, (select category_id from public.categories where name = 'Sports')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Dog Food & Treats', 'อาหารและขนมสุนัข', 'dog-food', '🐶', 801, (select category_id from public.categories where name = 'Pet Care')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Cat Food & Litter', 'อาหารและทรายแมว', 'cat-food', '🐱', 802, (select category_id from public.categories where name = 'Pet Care')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Pet Accessories', 'อุปกรณ์สัตว์เลี้ยง', 'pet-accessories', '🦴', 803, (select category_id from public.categories where name = 'Pet Care')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Vitamins & Supplements', 'วิตามินและอาหารเสริม', 'vitamins-supplements', '🧪', 901, (select category_id from public.categories where name = 'Health & Wellness')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('First Aid & Care', 'ปฐมพยาบาลและหน้ากาก', 'first-aid-care', '🩹', 902, (select category_id from public.categories where name = 'Health & Wellness')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Healthy Drinks', 'เครื่องดื่มเพื่อสุขภาพ', 'healthy-drinks', '🍵', 903, (select category_id from public.categories where name = 'Health & Wellness')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Baby Milk & Food', 'นมและอาหารเด็ก', 'baby-milk-food', '🥛', 1001, (select category_id from public.categories where name = 'Mom & Baby')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Diapers & Wipes', 'ผ้าอ้อมและทิชชู่เปียก', 'diapers-wipes', '👶', 1002, (select category_id from public.categories where name = 'Mom & Baby')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Baby Gear', 'อุปกรณ์ดูแลเด็กอ่อน', 'baby-gear', '🧸', 1003, (select category_id from public.categories where name = 'Mom & Baby')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Pens & Notebooks', 'ปากกาและสมุดบันทึก', 'pens-notebooks', '✏️', 1101, (select category_id from public.categories where name = 'Office & Stationery')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Desk Organization', 'จัดระเบียบโต๊ะทำงาน', 'desk-organization', '🗂️', 1102, (select category_id from public.categories where name = 'Office & Stationery')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Printer & Supplies', 'กระดาษและอุปกรณ์สำนักงาน', 'printer-supplies', '🖨️', 1103, (select category_id from public.categories where name = 'Office & Stationery')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Gardening', 'อุปกรณ์ทำสวน', 'gardening', '🪴', 1201, (select category_id from public.categories where name = 'Garden & Auto')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Car Care', 'ดูแลรักษารถยนต์', 'car-care', '🚗', 1202, (select category_id from public.categories where name = 'Garden & Auto')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;
insert into public.categories (name, name_th, slug, icon, sort_order, parent_id) values ('Lighting & Solar', 'ไฟโซลาร์และส่องสว่าง', 'lighting-solar', '☀️', 1203, (select category_id from public.categories where name = 'Garden & Auto')) on conflict (name) do update set name_th = excluded.name_th, slug = excluded.slug, icon = excluded.icon, sort_order = excluded.sort_order, parent_id = excluded.parent_id;

-- 3. Upsert 263 products (enrich existing, insert new + INITIAL stock_movements)
do $$
declare
    v_shop_id bigint;
    v_cat_id  integer;
    v_pid     bigint;
begin
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'Ceramic coffee mug 350 ml' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Ceramic coffee mug 350 ml', 'แก้วกาแฟเซรามิก 350 มล. เข้าไมโครเวฟได้ เก็บความร้อนดี ล้างทำความสะอาดง่าย', v_cat_id, 129, 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Somsri Craft', 'FDE-0001', '8850000000001', 'ใบ', 1, array['bestseller', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แก้วกาแฟเซรามิก 350 มล. เข้าไมโครเวฟได้ เก็บความร้อนดี ล้างทำความสะอาดง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0001', barcode = '8850000000001', unit = 'ใบ', pack_qty = 1, tags = array['bestseller', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'Linen cushion cover 45x45' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Linen cushion cover 45x45', 'ปลอกหมอนอิงผ้าลินินธรรมชาติ ขนาด 45x45 ซม. ระบายอากาศดี ซิปซ่อนเรียบร้อย', v_cat_id, 259, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 25, 5, true, 'Somsri Craft', 'FDE-0002', '8850000000002', 'ชิ้น', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปลอกหมอนอิงผ้าลินินธรรมชาติ ขนาด 45x45 ซม. ระบายอากาศดี ซิปซ่อนเรียบร้อย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0002', barcode = '8850000000002', unit = 'ชิ้น', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'Bamboo cutting board' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Bamboo cutting board', 'เขียงไม้ไผ่ธรรมชาติ แข็งแรง ทนทาน ไม่เป็นขุย ปลอดภัยต่อการประกอบอาหาร', v_cat_id, 349, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 15, 5, true, 'Somsri Craft', 'FDE-0003', '8850000000003', 'ชิ้น', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 15, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เขียงไม้ไผ่ธรรมชาติ แข็งแรง ทนทาน ไม่เป็นขุย ปลอดภัยต่อการประกอบอาหาร', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0003', barcode = '8850000000003', unit = 'ชิ้น', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fragrance & Aroma';
    select product_id into v_pid from public.products where name = 'Scented soy candle' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Scented soy candle', 'เทียนหอมไขถั่วเหลือง 100% กลิ่นลาเวนเดอร์วานิลลา จุดได้นาน 35 ชั่วโมง', v_cat_id, 199, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop', 3, 5, true, 'Somsri Aroma', 'FDE-0004', '8850000000004', 'กระปุก', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 3, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เทียนหอมไขถั่วเหลือง 100% กลิ่นลาเวนเดอร์วานิลลา จุดได้นาน 35 ชั่วโมง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Aroma', sku = 'FDE-0004', barcode = '8850000000004', unit = 'กระปุก', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'Cotton tote bag' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Cotton tote bag', 'กระเป๋าผ้าแคนวาสคอตตอนหนา 12 ออนซ์ จุของได้เยอะ ซักได้ ใช้แทนถุงพลาสติก', v_cat_id, 159, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Somsri Craft', 'FDE-0005', '8850000000005', 'ใบ', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระเป๋าผ้าแคนวาสคอตตอนหนา 12 ออนซ์ จุของได้เยอะ ซักได้ ใช้แทนถุงพลาสติก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0005', barcode = '8850000000005', unit = 'ใบ', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bottles & Hydration';
    select product_id into v_pid from public.products where name = 'Glass water bottle 600 ml' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Glass water bottle 600 ml', 'ขวดน้ำแก้วโบโรซิลิเกต 600 มล. พร้อมปลอกซิลิโคนกันกระแทก BPA-Free', v_cat_id, 289, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop', 1, 5, true, 'Somsri Craft', 'FDE-0006', '8850000000006', 'ขวด', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 1, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขวดน้ำแก้วโบโรซิลิเกต 600 มล. พร้อมปลอกซิลิโคนกันกระแทก BPA-Free', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0006', barcode = '8850000000006', unit = 'ขวด', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'กระทะเทฟลอนไม่ติดกระทะ Tefal 28 ซม.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระทะเทฟลอนไม่ติดกระทะ Tefal 28 ซม.', 'กระทะเคลือบผิวกันติด Titanium 28 ซม. จุด Thermo-Signal ใช้ได้กับเตาแก๊สและเตาไฟฟ้า', v_cat_id, 890, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 22, 5, true, 'Tefal', 'FDE-0007', '8850000000007', 'ใบ', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 22, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระทะเคลือบผิวกันติด Titanium 28 ซม. จุด Thermo-Signal ใช้ได้กับเตาแก๊สและเตาไฟฟ้า', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Tefal', sku = 'FDE-0007', barcode = '8850000000007', unit = 'ใบ', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'หม้อหุงข้าวดิจิทัล Sharp 1.8 ลิตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หม้อหุงข้าวดิจิทัล Sharp 1.8 ลิตร', 'หม้อหุงข้าวดิจิทัลขนาด 1.8 ลิตร เคลือบกันติด ตั้งเวลาหุงล่วงหน้าได้ ผ่านมาตรฐาน มอก.', v_cat_id, 1590, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 14, 5, true, 'Sharp', 'FDE-0008', '8850000000008', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 14, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หม้อหุงข้าวดิจิทัลขนาด 1.8 ลิตร เคลือบกันติด ตั้งเวลาหุงล่วงหน้าได้ ผ่านมาตรฐาน มอก.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Sharp', sku = 'FDE-0008', barcode = '8850000000008', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'ชุดกล่องถนอมอาหาร LocknLock 6 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดกล่องถนอมอาหาร LocknLock 6 ชิ้น', 'กล่องถนอมอาหารสุญญากาศ BPA-Free ฝาล็อก 4 ด้าน ไม่รั่วซึม เข้าไมโครเวฟได้ (ชุด 6 ใบ)', v_cat_id, 450, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'LocknLock', 'FDE-0009', '8850000000009', 'ชุด 6 ชิ้น', 6, array['bestseller', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล่องถนอมอาหารสุญญากาศ BPA-Free ฝาล็อก 4 ด้าน ไม่รั่วซึม เข้าไมโครเวฟได้ (ชุด 6 ใบ)', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'LocknLock', sku = 'FDE-0009', barcode = '8850000000009', unit = 'ชุด 6 ชิ้น', pack_qty = 6, tags = array['bestseller', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'กาต้มน้ำไฟฟ้าสแตนเลส Philips 1.7 ลิตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กาต้มน้ำไฟฟ้าสแตนเลส Philips 1.7 ลิตร', 'กาต้มน้ำไฟฟ้า 2200W เดือดไว ตัดไฟอัตโนมัติ ตัวเครื่องสแตนเลส 304 ปลอดภัย', v_cat_id, 790, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'Philips', 'FDE-0010', '8850000000010', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กาต้มน้ำไฟฟ้า 2200W เดือดไว ตัดไฟอัตโนมัติ ตัวเครื่องสแตนเลส 304 ปลอดภัย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Philips', sku = 'FDE-0010', barcode = '8850000000010', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'ชุดมีดทำครัวสแตนเลส Seagull 5 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดมีดทำครัวสแตนเลส Seagull 5 ชิ้น', 'ชุดมีดครัวสแตนเลสเกรด 420J2 คมกริบ พร้อมแท่นเสียบไม้ยางพารา', v_cat_id, 690, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'Seagull', 'FDE-0011', '8850000000011', 'ชุด 5 ชิ้น', 5, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดมีดครัวสแตนเลสเกรด 420J2 คมกริบ พร้อมแท่นเสียบไม้ยางพารา', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Seagull', sku = 'FDE-0011', barcode = '8850000000011', unit = 'ชุด 5 ชิ้น', pack_qty = 5, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'ชามเซรามิกญี่ปุ่นสไตล์มินิมอล แพ็ก 4 ใบ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชามเซรามิกญี่ปุ่นสไตล์มินิมอล แพ็ก 4 ใบ', 'ชามเซรามิกขนาด 6 นิ้ว เข้าเครื่องล้างจานและไมโครเวฟได้ แพ็กสุดคุ้ม 4 ใบ', v_cat_id, 390, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Somsri Craft', 'FDE-0012', '8850000000012', 'แพ็ก 4', 4, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชามเซรามิกขนาด 6 นิ้ว เข้าเครื่องล้างจานและไมโครเวฟได้ แพ็กสุดคุ้ม 4 ใบ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0012', barcode = '8850000000012', unit = 'แพ็ก 4', pack_qty = 4, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'แก้วกาแฟดริปพร้อมกรวยกรอง V60' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แก้วกาแฟดริปพร้อมกรวยกรอง V60', 'ชุดดริปกาแฟแก้วใสทนความร้อน 600 มล. พร้อมกรวย V60 และกระดาษกรอง 40 แผ่น', v_cat_id, 520, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 16, 5, true, 'Hario', 'FDE-0013', '8850000000013', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 16, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดดริปกาแฟแก้วใสทนความร้อน 600 มล. พร้อมกรวย V60 และกระดาษกรอง 40 แผ่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Hario', sku = 'FDE-0013', barcode = '8850000000013', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'ชุดผ้าปูที่นอนคอตตอน 100% 6 ฟุต 5 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดผ้าปูที่นอนคอตตอน 100% 6 ฟุต 5 ชิ้น', 'ผ้าปูที่นอนทอ 500 เส้นด้าย นุ่มลื่น ระบายอากาศดี ไม่เป็นขุย ครบชุด 6 ฟุต', v_cat_id, 1490, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Lotus', 'FDE-0014', '8850000000014', 'ชุด 5 ชิ้น', 5, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าปูที่นอนทอ 500 เส้นด้าย นุ่มลื่น ระบายอากาศดี ไม่เป็นขุย ครบชุด 6 ฟุต', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Lotus', sku = 'FDE-0014', barcode = '8850000000014', unit = 'ชุด 5 ชิ้น', pack_qty = 5, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'หมอนหนุนยางพาราแท้เพื่อสุขภาพ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หมอนหนุนยางพาราแท้เพื่อสุขภาพ', 'หมอนยางพาราแท้ 100% รองรับสรีระต้นคอ ลดอาการปวดคอ ป้องกันไรฝุ่น', v_cat_id, 790, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 24, 5, true, 'SiamLatex', 'FDE-0015', '8850000000015', 'ใบ', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 24, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หมอนยางพาราแท้ 100% รองรับสรีระต้นคอ ลดอาการปวดคอ ป้องกันไรฝุ่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'SiamLatex', sku = 'FDE-0015', barcode = '8850000000015', unit = 'ใบ', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'ผ้าห่มนวมไมโครไฟเบอร์ขนาด 6 ฟุต' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ผ้าห่มนวมไมโครไฟเบอร์ขนาด 6 ฟุต', 'ผ้าห่มนวมเนื้อนุ่มเบา ห่มสบายไม่ร้อน ซักเครื่องได้', v_cat_id, 990, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 15, 5, true, 'Lotus', 'FDE-0016', '8850000000016', 'ผืน', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 15, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าห่มนวมเนื้อนุ่มเบา ห่มสบายไม่ร้อน ซักเครื่องได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Lotus', sku = 'FDE-0016', barcode = '8850000000016', unit = 'ผืน', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'โคมไฟตั้งโต๊ะมินิมอลปรับแสงได้ 3 ระดับ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'โคมไฟตั้งโต๊ะมินิมอลปรับแสงได้ 3 ระดับ', 'โคมไฟตั้งโต๊ะ LED ถนอมสายตา แสงวอร์มไวท์/คูลไวท์ ฐานไม้จริงสไตล์มินิมอล', v_cat_id, 420, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'Somsri Craft', 'FDE-0017', '8850000000017', 'อัน', 1, array['tis']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โคมไฟตั้งโต๊ะ LED ถนอมสายตา แสงวอร์มไวท์/คูลไวท์ ฐานไม้จริงสไตล์มินิมอล', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0017', barcode = '8850000000017', unit = 'อัน', pack_qty = 1, tags = array['tis']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'พรมเช็ดเท้าหินเช็ดเท้าไดอะตอมไมท์ ซับน้ำทันที' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'พรมเช็ดเท้าหินเช็ดเท้าไดอะตอมไมท์ ซับน้ำทันที', 'แผ่นเช็ดเท้าหินซับน้ำแห้งไวใน 5 วินาที ลดการสะสมของแบคทีเรียและเชื้อรา', v_cat_id, 249, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Somsri Craft', 'FDE-0018', '8850000000018', 'ผืน', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แผ่นเช็ดเท้าหินซับน้ำแห้งไวใน 5 วินาที ลดการสะสมของแบคทีเรียและเชื้อรา', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0018', barcode = '8850000000018', unit = 'ผืน', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'น้ำยาล้างจานซันไลต์ เลมอนเทอร์โบ 750 มล. แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาล้างจานซันไลต์ เลมอนเทอร์โบ 750 มล. แพ็ก 3', 'น้ำยาล้างจานขจัดคราบมันเร็ว สูตรมะนาวเข้มข้น แพ็กประหยัด 3 ถุงเติม', v_cat_id, 165, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'Sunlight', 'FDE-0019', '8850000000019', 'แพ็ก 3', 3, array['bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำยาล้างจานขจัดคราบมันเร็ว สูตรมะนาวเข้มข้น แพ็กประหยัด 3 ถุงเติม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Sunlight', sku = 'FDE-0019', barcode = '8850000000019', unit = 'แพ็ก 3', pack_qty = 3, tags = array['bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'ผงซักฟอกบรีส เอกเซล 1400 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ผงซักฟอกบรีส เอกเซล 1400 กรัม แพ็ก 2', 'ผงซักฟอกสูตรเข้มข้นขจัดคราบหนักใน 1 นาที หอมสดชื่นยาวนาน', v_cat_id, 238, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Breeze', 'FDE-0020', '8850000000020', 'แพ็ก 2', 2, array['bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผงซักฟอกสูตรเข้มข้นขจัดคราบหนักใน 1 นาที หอมสดชื่นยาวนาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Breeze', sku = 'FDE-0020', barcode = '8850000000020', unit = 'แพ็ก 2', pack_qty = 2, tags = array['bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'น้ำยาปรับผ้านุ่มดาวน์นี่ ซันไรส์ เฟรช 1.35 ลิตร แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาปรับผ้านุ่มดาวน์นี่ ซันไรส์ เฟรช 1.35 ลิตร แพ็ก 2', 'น้ำยาปรับผ้านุ่มสูตรเข้มข้นพิเศษ หอมติดทนนานตลอดวัน แพ็กคู่สุดคุ้ม', v_cat_id, 279, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Downy', 'FDE-0021', '8850000000021', 'แพ็ก 2', 2, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำยาปรับผ้านุ่มสูตรเข้มข้นพิเศษ หอมติดทนนานตลอดวัน แพ็กคู่สุดคุ้ม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Downy', sku = 'FDE-0021', barcode = '8850000000021', unit = 'แพ็ก 2', pack_qty = 2, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'ไม้ถูพื้นไมโครไฟเบอร์พร้อมถังปั่นสแตนเลส' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไม้ถูพื้นไมโครไฟเบอร์พร้อมถังปั่นสแตนเลส', 'ชุดถังปั่นม็อบสแตนเลสแข็งแรง ผ้าม็อบไมโครไฟเบอร์ดักจับฝุ่นและเส้นผมได้ดีเยี่ยม', v_cat_id, 650, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 25, 5, true, 'Scotch-Brite', 'FDE-0022', '8850000000022', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดถังปั่นม็อบสแตนเลสแข็งแรง ผ้าม็อบไมโครไฟเบอร์ดักจับฝุ่นและเส้นผมได้ดีเยี่ยม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Scotch-Brite', sku = 'FDE-0022', barcode = '8850000000022', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'น้ำยาถูพื้นมาจิคลีน กลิ่นลาเวนเดอร์ 5200 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาถูพื้นมาจิคลีน กลิ่นลาเวนเดอร์ 5200 มล.', 'แกลลอนใหญ่สุดคุ้ม พื้นแห้งไว ไม่เหนียวเท้า ลดกลิ่นอับและแบคทีเรีย', v_cat_id, 285, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Magiclean', 'FDE-0023', '8850000000023', 'แกลลอน', 1, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แกลลอนใหญ่สุดคุ้ม พื้นแห้งไว ไม่เหนียวเท้า ลดกลิ่นอับและแบคทีเรีย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Magiclean', sku = 'FDE-0023', barcode = '8850000000023', unit = 'แกลลอน', pack_qty = 1, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'ถุงขยะดำแบบหนา 24x28 นิ้ว แพ็ก 6 ม้วน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ถุงขยะดำแบบหนา 24x28 นิ้ว แพ็ก 6 ม้วน', 'ถุงขยะเหนียวพิเศษรับน้ำหนักได้ดี มีเชือกผูกปากถุง แพ็ก 6 ม้วน (120 ใบ)', v_cat_id, 189, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'Champion', 'FDE-0024', '8850000000024', 'แพ็ก 6', 6, array['wholesale', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ถุงขยะเหนียวพิเศษรับน้ำหนักได้ดี มีเชือกผูกปากถุง แพ็ก 6 ม้วน (120 ใบ)', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Champion', sku = 'FDE-0024', barcode = '8850000000024', unit = 'แพ็ก 6', pack_qty = 6, tags = array['wholesale', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'สเปรย์ดับกลิ่นผ้าและโซฟา Febreze 370 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สเปรย์ดับกลิ่นผ้าและโซฟา Febreze 370 มล.', 'สเปรย์ขจัดกลิ่นอับบนผ้า ม่าน โซฟา และรองเท้า กำจัดแบคทีเรีย 99.9%', v_cat_id, 159, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Febreze', 'FDE-0025', '8850000000025', 'ขวด', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สเปรย์ขจัดกลิ่นอับบนผ้า ม่าน โซฟา และรองเท้า กำจัดแบคทีเรีย 99.9%', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Febreze', sku = 'FDE-0025', barcode = '8850000000025', unit = 'ขวด', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'กระดาษทิชชู่เช็ดหน้า Scott 150 แผ่น แพ็ก 4 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระดาษทิชชู่เช็ดหน้า Scott 150 แผ่น แพ็ก 4 กล่อง', 'กระดาษเช็ดหน้าหนานุ่ม 2 ชั้น ผลิตจากเยื่อกระดาษบริสุทธิ์ 100%', v_cat_id, 149, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 100, 5, true, 'Scott', 'FDE-0026', '8850000000026', 'แพ็ก 4', 4, array['bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 100, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระดาษเช็ดหน้าหนานุ่ม 2 ชั้น ผลิตจากเยื่อกระดาษบริสุทธิ์ 100%', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Scott', sku = 'FDE-0026', barcode = '8850000000026', unit = 'แพ็ก 4', pack_qty = 4, tags = array['bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'กระดาษชำระ Zilk เหนียวนุ่ม แพ็ก 24 ม้วน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระดาษชำระ Zilk เหนียวนุ่ม แพ็ก 24 ม้วน', 'กระดาษชำระความยาวพิเศษ แพ็กใหญ่ 24 ม้วน คุ้มค่าราคาส่ง', v_cat_id, 215, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Zilk', 'FDE-0027', '8850000000027', 'แพ็ก 24', 24, array['wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระดาษชำระความยาวพิเศษ แพ็กใหญ่ 24 ม้วน คุ้มค่าราคาส่ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Zilk', sku = 'FDE-0027', barcode = '8850000000027', unit = 'แพ็ก 24', pack_qty = 24, tags = array['wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'ชุดจานเมลามีน Superware 12 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดจานเมลามีน Superware 12 ชิ้น', 'ชุดจานชามเมลามีนแท้ 100% ทนความร้อนสูง ตกไม่แตกง่าย สำหรับครอบครัวหรือร้านอาหาร', v_cat_id, 790, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'Superware', 'FDE-0028', '8850000000028', 'ชุด 12 ชิ้น', 12, array['tis', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดจานชามเมลามีนแท้ 100% ทนความร้อนสูง ตกไม่แตกง่าย สำหรับครอบครัวหรือร้านอาหาร', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Superware', sku = 'FDE-0028', barcode = '8850000000028', unit = 'ชุด 12 ชิ้น', pack_qty = 12, tags = array['tis', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'กล่องเก็บของพลาสติกพับได้มีล้อ 55 ลิตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล่องเก็บของพลาสติกพับได้มีล้อ 55 ลิตร', 'กล่องจัดระเบียบบ้านเปิดได้ทั้งด้านบนและด้านหน้า พับเก็บได้ วางซ้อนกันได้มั่นคง', v_cat_id, 329, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Somsri Craft', 'FDE-0029', '8850000000029', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล่องจัดระเบียบบ้านเปิดได้ทั้งด้านบนและด้านหน้า พับเก็บได้ วางซ้อนกันได้มั่นคง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0029', barcode = '8850000000029', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'เครื่องกรองอากาศตั้งโต๊ะกรองฝุ่น PM2.5' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องกรองอากาศตั้งโต๊ะกรองฝุ่น PM2.5', 'เครื่องฟอกอากาศระบบ Plasmacluster + HEPA Filter สำหรับห้องขนาด 23 ตร.ม.', v_cat_id, 2990, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 11, 5, true, 'Sharp', 'FDE-0030', '8850000000030', 'เครื่อง', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 11, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องฟอกอากาศระบบ Plasmacluster + HEPA Filter สำหรับห้องขนาด 23 ตร.ม.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Sharp', sku = 'FDE-0030', barcode = '8850000000030', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'USB-C fast charger 30W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'USB-C fast charger 30W', 'หัวชาร์จเร็ว GaN USB-C 30W ขนาดกะทัดรัด รองรับ PD/PPS ชาร์จมือถือและแท็บเล็ตไว', v_cat_id, 490, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Anker', 'FDE-0031', '8850000000031', 'ชิ้น', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หัวชาร์จเร็ว GaN USB-C 30W ขนาดกะทัดรัด รองรับ PD/PPS ชาร์จมือถือและแท็บเล็ตไว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'Anker', sku = 'FDE-0031', barcode = '8850000000031', unit = 'ชิ้น', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'Wireless earbuds' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Wireless earbuds', 'หูฟังไร้สาย Bluetooth 5.3 ตัดเสียงรบกวน ANC แบตอึด 32 ชั่วโมง กันน้ำ IPX5', v_cat_id, 1290, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Soundcore', 'FDE-0032', '8850000000032', 'กล่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หูฟังไร้สาย Bluetooth 5.3 ตัดเสียงรบกวน ANC แบตอึด 32 ชั่วโมง กันน้ำ IPX5', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Soundcore', sku = 'FDE-0032', barcode = '8850000000032', unit = 'กล่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'Phone stand aluminium' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Phone stand aluminium', 'แท่นวางมือถืออะลูมิเนียมอัลลอย ปรับองศาได้ พับพกพาสะดวก มียางกันลื่น', v_cat_id, 350, 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'UGREEN', 'FDE-0033', '8850000000033', 'ชิ้น', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แท่นวางมือถืออะลูมิเนียมอัลลอย ปรับองศาได้ พับพกพาสะดวก มียางกันลื่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0033', barcode = '8850000000033', unit = 'ชิ้น', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'Mechanical keyboard 75%' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Mechanical keyboard 75%', 'คีย์บอร์ดเมคานิคอลขนาด 75% Hot-Swappable เชื่อมต่อ Bluetooth/USB-C ไฟ RGB', v_cat_id, 2490, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 4, 5, true, 'Keychron', 'FDE-0034', '8850000000034', 'ตัว', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 4, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'คีย์บอร์ดเมคานิคอลขนาด 75% Hot-Swappable เชื่อมต่อ Bluetooth/USB-C ไฟ RGB', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Keychron', sku = 'FDE-0034', barcode = '8850000000034', unit = 'ตัว', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'Laptop sleeve 14 inch' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'Laptop sleeve 14 inch', 'ซองใส่โน้ตบุ๊ก 14 นิ้ว กันกระแทกมุม 360 องศา ผ้ากันละอองน้ำ ซิป YKK', v_cat_id, 590, 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'Tomtoc', 'FDE-0035', '8850000000035', 'ใบ', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซองใส่โน้ตบุ๊ก 14 นิ้ว กันกระแทกมุม 360 องศา ผ้ากันละอองน้ำ ซิป YKK', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=600&q=70&auto=format&fit=crop'), brand = 'Tomtoc', sku = 'FDE-0035', barcode = '8850000000035', unit = 'ใบ', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'หัวชาร์จเร็ว GaN 65W 3 พอร์ต UGREEN Nexode' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หัวชาร์จเร็ว GaN 65W 3 พอร์ต UGREEN Nexode', 'หัวชาร์จ GaN 65W 2xUSB-C + 1xUSB-A ชาร์จโน้ตบุ๊กและมือถือพร้อมกันได้', v_cat_id, 990, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 25, 5, true, 'UGREEN', 'FDE-0036', '8850000000036', 'ชิ้น', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หัวชาร์จ GaN 65W 2xUSB-C + 1xUSB-A ชาร์จโน้ตบุ๊กและมือถือพร้อมกันได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0036', barcode = '8850000000036', unit = 'ชิ้น', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'สายชาร์จเร็ว USB-C to C 100W ถักไนลอน 2 เมตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สายชาร์จเร็ว USB-C to C 100W ถักไนลอน 2 เมตร', 'สายชาร์จถักไนลอนทนทาน รองรับไฟสูงสุด 100W PD ชิป E-Marker ปลอดภัย', v_cat_id, 229, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'UGREEN', 'FDE-0037', '8850000000037', 'เส้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สายชาร์จถักไนลอนทนทาน รองรับไฟสูงสุด 100W PD ชิป E-Marker ปลอดภัย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0037', barcode = '8850000000037', unit = 'เส้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'พาวเวอร์แบงค์ 20,000 mAh ชาร์จเร็ว 22.5W Eloop E29' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'พาวเวอร์แบงค์ 20,000 mAh ชาร์จเร็ว 22.5W Eloop E29', 'แบตสำรองความจุแท้ 20,000 mAh ผ่านมาตรฐาน มอก. พกขึ้นเครื่องบินได้', v_cat_id, 690, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Eloop', 'FDE-0038', '8850000000038', 'เครื่อง', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แบตสำรองความจุแท้ 20,000 mAh ผ่านมาตรฐาน มอก. พกขึ้นเครื่องบินได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'Eloop', sku = 'FDE-0038', barcode = '8850000000038', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'ปลั๊กพ่วงกันไฟกระชาก 4 ช่อง + USB-C 3 เมตร Toshino' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปลั๊กพ่วงกันไฟกระชาก 4 ช่อง + USB-C 3 เมตร Toshino', 'รางปลั๊กไฟมาตรฐาน มอก.2432-2555 รองรับกำลังไฟ 2300W มีสวิตช์แยกทุกช่อง', v_cat_id, 459, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 36, 5, true, 'Toshino', 'FDE-0039', '8850000000039', 'อัน', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 36, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'รางปลั๊กไฟมาตรฐาน มอก.2432-2555 รองรับกำลังไฟ 2300W มีสวิตช์แยกทุกช่อง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'Toshino', sku = 'FDE-0039', barcode = '8850000000039', unit = 'อัน', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'แท่นชาร์จไร้สายแม่เหล็ก MagSafe 15W Anker' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แท่นชาร์จไร้สายแม่เหล็ก MagSafe 15W Anker', 'แท่นชาร์จไร้สายแม่เหล็กแรงดูดสูง พับตั้งดูวิดีโอได้ รองรับ Qi2', v_cat_id, 1190, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'Anker', 'FDE-0040', '8850000000040', 'ชิ้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แท่นชาร์จไร้สายแม่เหล็กแรงดูดสูง พับตั้งดูวิดีโอได้ รองรับ Qi2', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'Anker', sku = 'FDE-0040', barcode = '8850000000040', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'อะแดปเตอร์แปลงหัวปลั๊กเดินทางทั่วโลก 65W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อะแดปเตอร์แปลงหัวปลั๊กเดินทางทั่วโลก 65W', 'Universal Travel Adapter ใช้ได้กว่า 150 ประเทศ มีพอร์ต USB-C ชาร์จเร็วในตัว', v_cat_id, 850, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'UGREEN', 'FDE-0041', '8850000000041', 'ชิ้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'Universal Travel Adapter ใช้ได้กว่า 150 ประเทศ มีพอร์ต USB-C ชาร์จเร็วในตัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0041', barcode = '8850000000041', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'หูฟังครอบหูตัดเสียงรบกวน Sony WH-CH720N' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หูฟังครอบหูตัดเสียงรบกวน Sony WH-CH720N', 'หูฟัง Over-Ear น้ำหนักเบา ตัดเสียงรบกวน Dual Noise Sensor แบตอึด 35 ชม.', v_cat_id, 3490, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 9, 5, true, 'Sony', 'FDE-0042', '8850000000042', 'กล่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 9, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หูฟัง Over-Ear น้ำหนักเบา ตัดเสียงรบกวน Dual Noise Sensor แบตอึด 35 ชม.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Sony', sku = 'FDE-0042', barcode = '8850000000042', unit = 'กล่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'ลำโพงบลูทูธพกพากันน้ำ JBL Go 4' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ลำโพงบลูทูธพกพากันน้ำ JBL Go 4', 'ลำโพงพกพาเสียงเบสแน่น กันน้ำกันฝุ่น IP67 แบตใช้งานต่อเนื่อง 7 ชั่วโมง', v_cat_id, 1690, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 22, 5, true, 'JBL', 'FDE-0043', '8850000000043', 'เครื่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 22, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ลำโพงพกพาเสียงเบสแน่น กันน้ำกันฝุ่น IP67 แบตใช้งานต่อเนื่อง 7 ชั่วโมง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'JBL', sku = 'FDE-0043', barcode = '8850000000043', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'นาฬิกาสมาร์ทวอทช์ออกกำลังกาย Xiaomi Band 9' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นาฬิกาสมาร์ทวอทช์ออกกำลังกาย Xiaomi Band 9', 'สายรัดข้อมืออัจฉริยะ จอ AMOLED 60Hz วัดชีพจร ออกซิเจนในเลือด แบต 21 วัน', v_cat_id, 1190, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Xiaomi', 'FDE-0044', '8850000000044', 'เรือน', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สายรัดข้อมืออัจฉริยะ จอ AMOLED 60Hz วัดชีพจร ออกซิเจนในเลือด แบต 21 วัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Xiaomi', sku = 'FDE-0044', barcode = '8850000000044', unit = 'เรือน', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'ไมโครโฟนไร้สายติดปกเสื้อ 2 ตัว สำหรับไลฟ์สด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไมโครโฟนไร้สายติดปกเสื้อ 2 ตัว สำหรับไลฟ์สด', 'ไมค์หนีบปกเสื้อไร้สาย USB-C ตัดเสียงรบกวนรอบข้าง ชาร์จผ่านเคสได้', v_cat_id, 990, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 17, 5, true, 'Boya', 'FDE-0045', '8850000000045', 'ชุด', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 17, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไมค์หนีบปกเสื้อไร้สาย USB-C ตัดเสียงรบกวนรอบข้าง ชาร์จผ่านเคสได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Boya', sku = 'FDE-0045', barcode = '8850000000045', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'หูฟังอินเอียร์มีสาย USB-C เสียงชัดพร้อมไมค์' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หูฟังอินเอียร์มีสาย USB-C เสียงชัดพร้อมไมค์', 'หูฟังมีสายหัวต่อ USB-C ไมค์ชัดคุยงาน/ประชุมออนไลน์ไม่ดีเลย์', v_cat_id, 390, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Sony', 'FDE-0046', '8850000000046', 'เส้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หูฟังมีสายหัวต่อ USB-C ไมค์ชัดคุยงาน/ประชุมออนไลน์ไม่ดีเลย์', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Sony', sku = 'FDE-0046', barcode = '8850000000046', unit = 'เส้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'เมาส์ไร้สายเงียบ Logitech M331 Silent Plus' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เมาส์ไร้สายเงียบ Logitech M331 Silent Plus', 'เมาส์ไร้สายคลิกเงียบลดเสียง 90% จับถนัดมือ แบตเตอรี่ใช้งานได้นาน 24 เดือน', v_cat_id, 590, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 38, 5, true, 'Logitech', 'FDE-0047', '8850000000047', 'ตัว', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 38, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เมาส์ไร้สายคลิกเงียบลดเสียง 90% จับถนัดมือ แบตเตอรี่ใช้งานได้นาน 24 เดือน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Logitech', sku = 'FDE-0047', barcode = '8850000000047', unit = 'ตัว', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'เมาส์เพื่อสุขภาพแนวตั้ง Logitech Lift Vertical' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เมาส์เพื่อสุขภาพแนวตั้ง Logitech Lift Vertical', 'เมาส์ Vertical ลดอาการปวดข้อมือ เชื่อมต่อได้ 3 อุปกรณ์ ผ่าน Bluetooth/Bolt', v_cat_id, 2290, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 10, 5, true, 'Logitech', 'FDE-0048', '8850000000048', 'ตัว', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 10, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เมาส์ Vertical ลดอาการปวดข้อมือ เชื่อมต่อได้ 3 อุปกรณ์ ผ่าน Bluetooth/Bolt', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Logitech', sku = 'FDE-0048', barcode = '8850000000048', unit = 'ตัว', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'ฮับแปลงพอร์ต USB-C 7-in-1 HDMI 4K + PD 100W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ฮับแปลงพอร์ต USB-C 7-in-1 HDMI 4K + PD 100W', 'USB-C Hub อะลูมิเนียม มี HDMI 4K, USB 3.0 x2, SD/TF Reader และชาร์จผ่าน 100W', v_cat_id, 790, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'UGREEN', 'FDE-0049', '8850000000049', 'ชิ้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'USB-C Hub อะลูมิเนียม มี HDMI 4K, USB 3.0 x2, SD/TF Reader และชาร์จผ่าน 100W', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0049', barcode = '8850000000049', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'เว็บแคม Full HD 1080p พร้อมไมค์คู่ Logitech C920e' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เว็บแคม Full HD 1080p พร้อมไมค์คู่ Logitech C920e', 'กล้องเว็บแคมภาพคมชัด 1080p ปรับแสงอัตโนมัติ มีฝาปิดเลนส์ความเป็นส่วนตัว', v_cat_id, 1990, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 14, 5, true, 'Logitech', 'FDE-0050', '8850000000050', 'ตัว', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 14, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล้องเว็บแคมภาพคมชัด 1080p ปรับแสงอัตโนมัติ มีฝาปิดเลนส์ความเป็นส่วนตัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Logitech', sku = 'FDE-0050', barcode = '8850000000050', unit = 'ตัว', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'SSD พกพาความเร็วสูง SanDisk Extreme 1TB' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'SSD พกพาความเร็วสูง SanDisk Extreme 1TB', 'SSD External ความเร็วอ่าน 1050MB/s กันน้ำกันฝุ่น IP65 ทนแรงกระแทก', v_cat_id, 3290, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'SanDisk', 'FDE-0051', '8850000000051', 'ชิ้น', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'SSD External ความเร็วอ่าน 1050MB/s กันน้ำกันฝุ่น IP65 ทนแรงกระแทก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'SanDisk', sku = 'FDE-0051', barcode = '8850000000051', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'กล้องวงจรปิด Wi-Fi หมุนได้ 360 องศา Tapo C210 2K' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล้องวงจรปิด Wi-Fi หมุนได้ 360 องศา Tapo C210 2K', 'กล้องวงจรปิดภายในบ้านความคมชัด 3MP 2K ดูผ่านมือถือ พูดคุยโต้ตอบได้ แจ้งเตือนเคลื่อนไหว', v_cat_id, 790, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 42, 5, true, 'TP-Link', 'FDE-0052', '8850000000052', 'ตัว', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 42, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล้องวงจรปิดภายในบ้านความคมชัด 3MP 2K ดูผ่านมือถือ พูดคุยโต้ตอบได้ แจ้งเตือนเคลื่อนไหว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'TP-Link', sku = 'FDE-0052', barcode = '8850000000052', unit = 'ตัว', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'หลอดไฟอัจฉริยะ Wi-Fi เปลี่ยนสีได้ Philips Wiz 9W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หลอดไฟอัจฉริยะ Wi-Fi เปลี่ยนสีได้ Philips Wiz 9W', 'หลอดไฟ LED Smart ขั้ว E27 ปรับได้ 16 ล้านสี สั่งงานผ่านแอปและเสียงได้', v_cat_id, 299, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Philips', 'FDE-0053', '8850000000053', 'หลอด', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หลอดไฟ LED Smart ขั้ว E27 ปรับได้ 16 ล้านสี สั่งงานผ่านแอปและเสียงได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Philips', sku = 'FDE-0053', barcode = '8850000000053', unit = 'หลอด', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'ปลั๊กไฟอัจฉริยะ Smart Plug Wi-Fi วัดค่าไฟได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปลั๊กไฟอัจฉริยะ Smart Plug Wi-Fi วัดค่าไฟได้', 'ปลั๊กอัจฉริยะสั่งเปิด-ปิดผ่านมือถือ ตั้งเวลาอัตโนมัติ และดูสถิติการใช้พลังงาน', v_cat_id, 359, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 44, 5, true, 'TP-Link', 'FDE-0054', '8850000000054', 'ชิ้น', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 44, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปลั๊กอัจฉริยะสั่งเปิด-ปิดผ่านมือถือ ตั้งเวลาอัตโนมัติ และดูสถิติการใช้พลังงาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'TP-Link', sku = 'FDE-0054', barcode = '8850000000054', unit = 'ชิ้น', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'แท่นวางโน้ตบุ๊กอะลูมิเนียมปรับระดับได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แท่นวางโน้ตบุ๊กอะลูมิเนียมปรับระดับได้', 'ขาตั้งโน้ตบุ๊กระบายความร้อนดี ปรับระดับความสูง 5 ขั้น รองรับจอ 11-17 นิ้ว', v_cat_id, 549, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 25, 5, true, 'UGREEN', 'FDE-0055', '8850000000055', 'ชิ้น', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขาตั้งโน้ตบุ๊กระบายความร้อนดี ปรับระดับความสูง 5 ขั้น รองรับจอ 11-17 นิ้ว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0055', barcode = '8850000000055', unit = 'ชิ้น', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'แผ่นรองเมาส์โต๊ะทำงานขนาดใหญ่ 80x40 ซม. กันน้ำ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แผ่นรองเมาส์โต๊ะทำงานขนาดใหญ่ 80x40 ซม. กันน้ำ', 'แผ่นรองเมาส์หนัง PU และผ้าไมโครไฟเบอร์ เย็บขอบอย่างดี ทำความสะอาดง่าย', v_cat_id, 320, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Keychron', 'FDE-0056', '8850000000056', 'ผืน', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แผ่นรองเมาส์หนัง PU และผ้าไมโครไฟเบอร์ เย็บขอบอย่างดี ทำความสะอาดง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Keychron', sku = 'FDE-0056', barcode = '8850000000056', unit = 'ผืน', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'เราเตอร์ Wi-Fi 6 ความเร็วสูง AX3000 TP-Link Archer' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เราเตอร์ Wi-Fi 6 ความเร็วสูง AX3000 TP-Link Archer', 'เราเตอร์ Wi-Fi 6 Dual-Band รองรับอุปกรณ์พร้อมกันหลายเครื่อง สัญญาณแรงทั่วบ้าน', v_cat_id, 1890, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 15, 5, true, 'TP-Link', 'FDE-0057', '8850000000057', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 15, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เราเตอร์ Wi-Fi 6 Dual-Band รองรับอุปกรณ์พร้อมกันหลายเครื่อง สัญญาณแรงทั่วบ้าน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'TP-Link', sku = 'FDE-0057', barcode = '8850000000057', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'แฟลชไดรฟ์ 2 หัว USB-C & USB-A 128GB SanDisk' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แฟลชไดรฟ์ 2 หัว USB-C & USB-A 128GB SanDisk', 'แฟลชไดรฟ์ 2-in-1 โอนไฟล์ระหว่างมือถือและคอมพิวเตอร์ได้ทันที ความเร็ว USB 3.2', v_cat_id, 369, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'SanDisk', 'FDE-0058', '8850000000058', 'ชิ้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แฟลชไดรฟ์ 2-in-1 โอนไฟล์ระหว่างมือถือและคอมพิวเตอร์ได้ทันที ความเร็ว USB 3.2', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'SanDisk', sku = 'FDE-0058', barcode = '8850000000058', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำปลาแท้ ตราปลาหมึก 700 มล. แพ็ก 3 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำปลาแท้ ตราปลาหมึก 700 มล. แพ็ก 3 ขวด', 'น้ำปลาแท้หมักธรรมชาติจากปลากะตัก ไม่ใส่ผงชูรส ไม่เจือสี มี อย. และฮาลาล แพ็ก 3 ขวด', v_cat_id, 135, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 120, 5, true, 'ปลาหมึก (Squid)', 'FDE-0059', '8850000000059', 'แพ็ก 3', 3, array['halal', 'no_msg', 'fda', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 120, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำปลาแท้หมักธรรมชาติจากปลากะตัก ไม่ใส่ผงชูรส ไม่เจือสี มี อย. และฮาลาล แพ็ก 3 ขวด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ปลาหมึก (Squid)', sku = 'FDE-0059', barcode = '8850000000059', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'no_msg', 'fda', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำปลาแท้ ทิพรส 700 มล. แพ็ก 3 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำปลาแท้ ทิพรส 700 มล. แพ็ก 3 ขวด', 'น้ำปลาแท้ยอดนิยม หอมกลมกล่อม เหมาะสำหรับปรุงอาหารและทำน้ำจิ้มทุกชนิด', v_cat_id, 126, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 110, 5, true, 'ทิพรส (Tiparos)', 'FDE-0060', '8850000000060', 'แพ็ก 3', 3, array['halal', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 110, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำปลาแท้ยอดนิยม หอมกลมกล่อม เหมาะสำหรับปรุงอาหารและทำน้ำจิ้มทุกชนิด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ทิพรส (Tiparos)', sku = 'FDE-0060', barcode = '8850000000060', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำปลาแท้ เมกะเชฟ สูตรลดโซเดียม 500 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำปลาแท้ เมกะเชฟ สูตรลดโซเดียม 500 มล.', 'น้ำปลาแท้หมักนาน 2 ปี ไม่ใส่ผงชูรส ไม่ใส่สารกันบูด โซเดียมต่ำ กลิ่นหอมนุ่ม', v_cat_id, 78, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'เมกะเชฟ (Megachef)', 'FDE-0061', '8850000000061', 'ขวด', 1, array['halal', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำปลาแท้หมักนาน 2 ปี ไม่ใส่ผงชูรส ไม่ใส่สารกันบูด โซเดียมต่ำ กลิ่นหอมนุ่ม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'เมกะเชฟ (Megachef)', sku = 'FDE-0061', barcode = '8850000000061', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ซีอิ๊วขาวสูตร 1 เด็กสมบูรณ์ 700 มล. แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซีอิ๊วขาวสูตร 1 เด็กสมบูรณ์ 700 มล. แพ็ก 3', 'ซีอิ๊วขาวหมักจากถั่วเหลืองคัดพิเศษ ใช้ปรุงอาหารเจและอาหารทั่วไปได้', v_cat_id, 147, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 100, 5, true, 'เด็กสมบูรณ์', 'FDE-0062', '8850000000062', 'แพ็ก 3', 3, array['halal', 'vegan', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 100, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซีอิ๊วขาวหมักจากถั่วเหลืองคัดพิเศษ ใช้ปรุงอาหารเจและอาหารทั่วไปได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'เด็กสมบูรณ์', sku = 'FDE-0062', barcode = '8850000000062', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ซอสหอยนางรม แม่ครัว 600 มล. แพ็ก 3 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซอสหอยนางรม แม่ครัว 600 มล. แพ็ก 3 ขวด', 'ซอสหอยนางรมเข้มข้น หอมกลมกล่อม ผัดผักและหมักเนื้ออร่อยลงตัว', v_cat_id, 159, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 95, 5, true, 'แม่ครัว', 'FDE-0063', '8850000000063', 'แพ็ก 3', 3, array['fda', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 95, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซอสหอยนางรมเข้มข้น หอมกลมกล่อม ผัดผักและหมักเนื้ออร่อยลงตัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'แม่ครัว', sku = 'FDE-0063', barcode = '8850000000063', unit = 'แพ็ก 3', pack_qty = 3, tags = array['fda', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ซอสปรุงรสฝาเขียว ภูเขาทอง 600 มล. แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซอสปรุงรสฝาเขียว ภูเขาทอง 600 มล. แพ็ก 3', 'ซอสปรุงรสอาหารสูตรต้นตำรับ เหยาะไข่ดาวหรือผัดกับข้าวหอมอร่อย', v_cat_id, 129, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'ภูเขาทอง', 'FDE-0064', '8850000000064', 'แพ็ก 3', 3, array['halal', 'vegan', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซอสปรุงรสอาหารสูตรต้นตำรับ เหยาะไข่ดาวหรือผัดกับข้าวหอมอร่อย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ภูเขาทอง', sku = 'FDE-0064', barcode = '8850000000064', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำมันรำข้าว คิง 1 ลิตร แพ็ก 3 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมันรำข้าว คิง 1 ลิตร แพ็ก 3 ขวด', 'น้ำมันรำข้าวโอรีซานอลสูง 8,000 ppm ทนความร้อนสูง ไร้ไขมันทรานส์ ดีต่อหัวใจ', v_cat_id, 235, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'คิง (King)', 'FDE-0065', '8850000000065', 'แพ็ก 3', 3, array['halal', 'vegan', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมันรำข้าวโอรีซานอลสูง 8,000 ppm ทนความร้อนสูง ไร้ไขมันทรานส์ ดีต่อหัวใจ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'คิง (King)', sku = 'FDE-0065', barcode = '8850000000065', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำมันมะกอกเอ็กซ์ตร้าเวอร์จิน Bertolli 500 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมันมะกอกเอ็กซ์ตร้าเวอร์จิน Bertolli 500 มล.', 'น้ำมันมะกอกสกัดเย็นคุณภาพเยี่ยม เหมาะสำหรับทำสลัดและอาหารเพื่อสุขภาพ', v_cat_id, 295, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Bertolli', 'FDE-0066', '8850000000066', 'ขวด', 1, array['halal', 'vegan', 'fda', 'organic']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมันมะกอกสกัดเย็นคุณภาพเยี่ยม เหมาะสำหรับทำสลัดและอาหารเพื่อสุขภาพ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'Bertolli', sku = 'FDE-0066', barcode = '8850000000066', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'vegan', 'fda', 'organic']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ข้าวหอมมะลิแท้ 100% ตราฉัตรทอง 5 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ข้าวหอมมะลิแท้ 100% ตราฉัตรทอง 5 กก.', 'ข้าวหอมมะลิใหม่ต้นฤดู เมล็ดเรียวยาว หุงขึ้นหม้อ หอมนุ่มอร่อย', v_cat_id, 249, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'ตราฉัตร', 'FDE-0067', '8850000000067', 'ถุง 5 กก.', 1, array['halal', 'vegan', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ข้าวหอมมะลิใหม่ต้นฤดู เมล็ดเรียวยาว หุงขึ้นหม้อ หอมนุ่มอร่อย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ตราฉัตร', sku = 'FDE-0067', barcode = '8850000000067', unit = 'ถุง 5 กก.', pack_qty = 1, tags = array['halal', 'vegan', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ข้าวไรซ์เบอร์รี่ออร์แกนิก 1 กก. แพ็ก 2 ถุง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ข้าวไรซ์เบอร์รี่ออร์แกนิก 1 กก. แพ็ก 2 ถุง', 'ข้าวไรซ์เบอร์รี่อินทรีย์แท้ ดัชนีน้ำตาลต่ำ อุดมด้วยสารต้านอนุมูลอิสระ', v_cat_id, 178, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'ดอยคำ', 'FDE-0068', '8850000000068', 'แพ็ก 2', 2, array['halal', 'vegan', 'organic', 'fda', 'low_sugar']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ข้าวไรซ์เบอร์รี่อินทรีย์แท้ ดัชนีน้ำตาลต่ำ อุดมด้วยสารต้านอนุมูลอิสระ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยคำ', sku = 'FDE-0068', barcode = '8850000000068', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'vegan', 'organic', 'fda', 'low_sugar']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'บะหมี่กึ่งสำเร็จรูป มาม่า ต้มยำกุ้ง ลัง 30 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'บะหมี่กึ่งสำเร็จรูป มาม่า ต้มยำกุ้ง ลัง 30 ซอง', 'มาม่ารสต้มยำกุ้งยอดฮิต ยกลัง 30 ซอง เฉลี่ยซองละไม่ถึง 7 บาท ราคาส่ง', v_cat_id, 205, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'มาม่า (Mama)', 'FDE-0069', '8850000000069', 'ลัง 30 ซอง', 30, array['halal', 'fda', 'wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'มาม่ารสต้มยำกุ้งยอดฮิต ยกลัง 30 ซอง เฉลี่ยซองละไม่ถึง 7 บาท ราคาส่ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'มาม่า (Mama)', sku = 'FDE-0069', barcode = '8850000000069', unit = 'ลัง 30 ซอง', pack_qty = 30, tags = array['halal', 'fda', 'wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำพริกเผาไทย แม่ประนอม 513 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำพริกเผาไทย แม่ประนอม 513 กรัม', 'น้ำพริกเผาสูตรดั้งเดิม ไม่ใส่ผงชูรส ไม่ใส่สี ไม่ใส่วัตถุกันเสีย ทำต้มยำหรือทาขนมปังอร่อย', v_cat_id, 118, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'แม่ประนอม', 'FDE-0070', '8850000000070', 'กระปุก', 1, array['halal', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำพริกเผาสูตรดั้งเดิม ไม่ใส่ผงชูรส ไม่ใส่สี ไม่ใส่วัตถุกันเสีย ทำต้มยำหรือทาขนมปังอร่อย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'แม่ประนอม', sku = 'FDE-0070', barcode = '8850000000070', unit = 'กระปุก', pack_qty = 1, tags = array['halal', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'กะทิแท้ 100% อร่อยดี 250 มล. แพ็ก 6 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กะทิแท้ 100% อร่อยดี 250 มล. แพ็ก 6 กล่อง', 'กะทิคั้นสด UHT ขาวข้นหอมมัน ไม่ใส่สารฟอกขาว สำหรับแกงไทยและขนมหวาน', v_cat_id, 156, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'อร่อยดี (Aroy-D)', 'FDE-0071', '8850000000071', 'แพ็ก 6', 6, array['halal', 'vegan', 'no_msg', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กะทิคั้นสด UHT ขาวข้นหอมมัน ไม่ใส่สารฟอกขาว สำหรับแกงไทยและขนมหวาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'อร่อยดี (Aroy-D)', sku = 'FDE-0071', barcode = '8850000000071', unit = 'แพ็ก 6', pack_qty = 6, tags = array['halal', 'vegan', 'no_msg', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'พริกแกงเขียวหวาน น้ำใจ 100 กรัม แพ็ก 4 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'พริกแกงเขียวหวาน น้ำใจ 100 กรัม แพ็ก 4 ซอง', 'พริกแกงไทยแท้จากสมุนไพรสด หอมเครื่องเทศ ไม่ใส่ผงชูรสและสารกันบูด', v_cat_id, 112, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'น้ำใจ', 'FDE-0072', '8850000000072', 'แพ็ก 4', 4, array['halal', 'no_msg', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'พริกแกงไทยแท้จากสมุนไพรสด หอมเครื่องเทศ ไม่ใส่ผงชูรสและสารกันบูด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'น้ำใจ', sku = 'FDE-0072', barcode = '8850000000072', unit = 'แพ็ก 4', pack_qty = 4, tags = array['halal', 'no_msg', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'เส้นสปาเก็ตตี้เบอร์ 3 Agnesi 500 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เส้นสปาเก็ตตี้เบอร์ 3 Agnesi 500 กรัม แพ็ก 2', 'เส้นพาสต้านำเข้าจากอิตาลี ผลิตจากข้าวสาลีดูรัม 100% เหนียวนุ่มหนึบ', v_cat_id, 145, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Agnesi', 'FDE-0073', '8850000000073', 'แพ็ก 2', 2, array['vegan', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เส้นพาสต้านำเข้าจากอิตาลี ผลิตจากข้าวสาลีดูรัม 100% เหนียวนุ่มหนึบ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'Agnesi', sku = 'FDE-0073', barcode = '8850000000073', unit = 'แพ็ก 2', pack_qty = 2, tags = array['vegan', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ปลาทูน่าในน้ำแร่ ซีเล็ค 165 กรัม แพ็ก 4 กระป๋อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปลาทูน่าในน้ำแร่ ซีเล็ค 165 กรัม แพ็ก 4 กระป๋อง', 'ทูน่าเนื้อล้วนในน้ำแร่ โปรตีนสูง ไขมันต่ำ 0% ไม่มีผงชูรส เหมาะกับสายคลีน', v_cat_id, 179, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'ซีเล็ค (Sealect)', 'FDE-0074', '8850000000074', 'แพ็ก 4', 4, array['halal', 'no_msg', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ทูน่าเนื้อล้วนในน้ำแร่ โปรตีนสูง ไขมันต่ำ 0% ไม่มีผงชูรส เหมาะกับสายคลีน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ซีเล็ค (Sealect)', sku = 'FDE-0074', barcode = '8850000000074', unit = 'แพ็ก 4', pack_qty = 4, tags = array['halal', 'no_msg', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำตาลหล่อฮังก๊วย 0 แคลอรี่ 250 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำตาลหล่อฮังก๊วย 0 แคลอรี่ 250 กรัม', 'สารให้ความหวานจากธรรมชาติ 0 แคลอรี่ ไม่กระตุ้นอินซูลิน คีโตและผู้คุมน้ำตาลทานได้', v_cat_id, 189, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'LakanThai', 'FDE-0075', '8850000000075', 'ถุง', 1, array['halal', 'vegan', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สารให้ความหวานจากธรรมชาติ 0 แคลอรี่ ไม่กระตุ้นอินซูลิน คีโตและผู้คุมน้ำตาลทานได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'LakanThai', sku = 'FDE-0075', barcode = '8850000000075', unit = 'ถุง', pack_qty = 1, tags = array['halal', 'vegan', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'เกลือหิมาลายันสีชมพูชนิดละเอียด 500 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เกลือหิมาลายันสีชมพูชนิดละเอียด 500 กรัม', 'เกลือชมพูธรรมชาติไม่ขัดสี อุดมแร่ธาตุ 84 ชนิด สำหรับปรุงอาหารสุขภาพ', v_cat_id, 89, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'Organic Siam', 'FDE-0076', '8850000000076', 'ขวด', 1, array['halal', 'vegan', 'organic', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เกลือชมพูธรรมชาติไม่ขัดสี อุดมแร่ธาตุ 84 ชนิด สำหรับปรุงอาหารสุขภาพ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'Organic Siam', sku = 'FDE-0076', barcode = '8850000000076', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'vegan', 'organic', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'กาแฟดริปอาราบิก้าคั่วกลาง ดอยช้าง กล่อง 10 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กาแฟดริปอาราบิก้าคั่วกลาง ดอยช้าง กล่อง 10 ซอง', 'กาแฟดริปอาราบิก้าแท้ 100% จากดอยช้าง หอมกลิ่นถั่วและช็อกโกแลต ไม่ใส่น้ำตาล', v_cat_id, 245, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'ดอยช้าง (Doi Chaang)', 'FDE-0077', '8850000000077', 'กล่อง 10 ซอง', 10, array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กาแฟดริปอาราบิก้าแท้ 100% จากดอยช้าง หอมกลิ่นถั่วและช็อกโกแลต ไม่ใส่น้ำตาล', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยช้าง (Doi Chaang)', sku = 'FDE-0077', barcode = '8850000000077', unit = 'กล่อง 10 ซอง', pack_qty = 10, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'เมล็ดกาแฟคั่วกลาง-เข้ม อาราบิก้าปางขอน 500 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เมล็ดกาแฟคั่วกลาง-เข้ม อาราบิก้าปางขอน 500 กรัม', 'เมล็ดกาแฟคั่วสดใหม่ หอมเข้มบาลานซ์ดี ชงได้ทั้งเอสเพรสโซและอเมริกาโน่', v_cat_id, 320, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Siam Roaster', 'FDE-0078', '8850000000078', 'ถุง 500 ก.', 1, array['halal', 'vegan', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เมล็ดกาแฟคั่วสดใหม่ หอมเข้มบาลานซ์ดี ชงได้ทั้งเอสเพรสโซและอเมริกาโน่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'Siam Roaster', sku = 'FDE-0078', barcode = '8850000000078', unit = 'ถุง 500 ก.', pack_qty = 1, tags = array['halal', 'vegan', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'ชาเขียวมัทฉะญี่ปุ่นแท้ 100% ไม่ผสมน้ำตาล 100 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชาเขียวมัทฉะญี่ปุ่นแท้ 100% ไม่ผสมน้ำตาล 100 กรัม', 'ผงมัทฉะเกรดพรีเมียมจากอูจิ สีเขียวสด หอมละมุน ไม่มีน้ำตาล ชงร้อนหรือเย็นได้', v_cat_id, 290, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Uji Matcha', 'FDE-0079', '8850000000079', 'ซอง', 1, array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผงมัทฉะเกรดพรีเมียมจากอูจิ สีเขียวสด หอมละมุน ไม่มีน้ำตาล ชงร้อนหรือเย็นได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'Uji Matcha', sku = 'FDE-0079', barcode = '8850000000079', unit = 'ซอง', pack_qty = 1, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'น้ำแร่ธรรมชาติ ออร่า 500 มล. แพ็ก 12 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำแร่ธรรมชาติ ออร่า 500 มล. แพ็ก 12 ขวด', 'น้ำแร่ธรรมชาติ 100% จากแหล่งน้ำพุเย็น อุดมแร่ธาตุ แพ็ก 12 ขวดคุ้มมาก', v_cat_id, 119, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 130, 5, true, 'ออร่า (Aura)', 'FDE-0080', '8850000000080', 'แพ็ก 12', 12, array['halal', 'low_sugar', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 130, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำแร่ธรรมชาติ 100% จากแหล่งน้ำพุเย็น อุดมแร่ธาตุ แพ็ก 12 ขวดคุ้มมาก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ออร่า (Aura)', sku = 'FDE-0080', barcode = '8850000000080', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'low_sugar', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'นมถั่วเหลือง แลคตาซอย สูตรไม่หวาน 300 มล. แพ็ก 12' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นมถั่วเหลือง แลคตาซอย สูตรไม่หวาน 300 มล. แพ็ก 12', 'นมถั่วเหลืองคั้นสดสูตรไม่เติมน้ำตาล โปรตีนสูง เจทานได้ แพ็ก 12 กล่อง', v_cat_id, 132, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 100, 5, true, 'แลคตาซอย', 'FDE-0081', '8850000000081', 'แพ็ก 12', 12, array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 100, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นมถั่วเหลืองคั้นสดสูตรไม่เติมน้ำตาล โปรตีนสูง เจทานได้ แพ็ก 12 กล่อง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'แลคตาซอย', sku = 'FDE-0081', barcode = '8850000000081', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'นมอัลมอนด์ 137 Degrees สูตรไม่หวาน 1000 มล. แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นมอัลมอนด์ 137 Degrees สูตรไม่หวาน 1000 มล. แพ็ก 3', 'นมอัลมอนด์คั้นจากเมล็ดอัลมอนด์เต็มเมล็ด 100% ไม่ใส่น้ำตาล ไม่มีแลคโตส', v_cat_id, 285, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 60, 5, true, '137 Degrees', 'FDE-0082', '8850000000082', 'แพ็ก 3', 3, array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นมอัลมอนด์คั้นจากเมล็ดอัลมอนด์เต็มเมล็ด 100% ไม่ใส่น้ำตาล ไม่มีแลคโตส', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = '137 Degrees', sku = 'FDE-0082', barcode = '8850000000082', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'น้ำมะเขือเทศ 100% ดอยคำ สูตรโซเดียมต่ำ 200 มล. แพ็ก 12' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมะเขือเทศ 100% ดอยคำ สูตรโซเดียมต่ำ 200 มล. แพ็ก 12', 'น้ำมะเขือเทศแท้ไม่เติมน้ำตาล โซเดียมต่ำ ไลโคปีนสูง บำรุงผิวพรรณ', v_cat_id, 216, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'ดอยคำ', 'FDE-0083', '8850000000083', 'แพ็ก 12', 12, array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมะเขือเทศแท้ไม่เติมน้ำตาล โซเดียมต่ำ ไลโคปีนสูง บำรุงผิวพรรณ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยคำ', sku = 'FDE-0083', barcode = '8850000000083', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'ชาไทยปรุงสำเร็จ ตรามือ ถุงแดง 400 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชาไทยปรุงสำเร็จ ตรามือ ถุงแดง 400 กรัม แพ็ก 2', 'ผงชาไทยสูตรต้นตำรับ หอมเข้มสีสวย ชงชาเย็น ชาดำเย็น หรือชามะนาวอร่อยสุดๆ', v_cat_id, 178, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'ชาตรามือ', 'FDE-0084', '8850000000084', 'แพ็ก 2', 2, array['halal', 'fda', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผงชาไทยสูตรต้นตำรับ หอมเข้มสีสวย ชงชาเย็น ชาดำเย็น หรือชามะนาวอร่อยสุดๆ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ชาตรามือ', sku = 'FDE-0084', barcode = '8850000000084', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'fda', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'โค้ก ซีโร่ ไม่มีน้ำตาล 325 มล. ลัง 24 กระป๋อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'โค้ก ซีโร่ ไม่มีน้ำตาล 325 มล. ลัง 24 กระป๋อง', 'น้ำอัดลมสูตรไม่มีน้ำตาล ซ่าสดชื่น 0 แคลอรี่ ยกลัง 24 กระป๋องราคาส่ง', v_cat_id, 349, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Coca-Cola', 'FDE-0085', '8850000000085', 'ลัง 24', 24, array['halal', 'low_sugar', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำอัดลมสูตรไม่มีน้ำตาล ซ่าสดชื่น 0 แคลอรี่ ยกลัง 24 กระป๋องราคาส่ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'Coca-Cola', sku = 'FDE-0085', barcode = '8850000000085', unit = 'ลัง 24', pack_qty = 24, tags = array['halal', 'low_sugar', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'นมยูเอชที ไทย-เดนมาร์ค รสจืด 200 มล. ลัง 36 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นมยูเอชที ไทย-เดนมาร์ค รสจืด 200 มล. ลัง 36 กล่อง', 'นมโคสดแท้ 100% ไม่ผสมนมผง แคลเซียมสูง ยกลัง 36 กล่องประหยัดสุดๆ', v_cat_id, 429, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'ไทย-เดนมาร์ค', 'FDE-0086', '8850000000086', 'ลัง 36', 36, array['halal', 'low_sugar', 'fda', 'wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นมโคสดแท้ 100% ไม่ผสมนมผง แคลเซียมสูง ยกลัง 36 กล่องประหยัดสุดๆ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ไทย-เดนมาร์ค', sku = 'FDE-0086', barcode = '8850000000086', unit = 'ลัง 36', pack_qty = 36, tags = array['halal', 'low_sugar', 'fda', 'wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'น้ำส้มวาเลนเซีย 100% มาลี 1000 มล. แพ็ก 3 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำส้มวาเลนเซีย 100% มาลี 1000 มล. แพ็ก 3 กล่อง', 'น้ำส้มคั้น 100% วิตามินซีสูง ไม่เติมน้ำตาล ไม่ใส่วัตถุกันเสีย', v_cat_id, 198, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'มาลี (Malee)', 'FDE-0087', '8850000000087', 'แพ็ก 3', 3, array['halal', 'vegan', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำส้มคั้น 100% วิตามินซีสูง ไม่เติมน้ำตาล ไม่ใส่วัตถุกันเสีย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'มาลี (Malee)', sku = 'FDE-0087', barcode = '8850000000087', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'โกโก้ผงแท้ดัตช์ 100% ทิวลิป 440 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'โกโก้ผงแท้ดัตช์ 100% ทิวลิป 440 กรัม', 'ผงโกโก้สีเข้ม ไขมันโกโก้ 10-12% หอมเข้มข้น ชงเครื่องดื่มและทำเบเกอรี่ได้', v_cat_id, 165, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'ทิวลิป (Tulip)', 'FDE-0088', '8850000000088', 'กล่อง', 1, array['halal', 'vegan', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผงโกโก้สีเข้ม ไขมันโกโก้ 10-12% หอมเข้มข้น ชงเครื่องดื่มและทำเบเกอรี่ได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ทิวลิป (Tulip)', sku = 'FDE-0088', barcode = '8850000000088', unit = 'กล่อง', pack_qty = 1, tags = array['halal', 'vegan', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'อัลมอนด์อบธรรมชาติไม่ใส่เกลือ Blue Diamond 150 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อัลมอนด์อบธรรมชาติไม่ใส่เกลือ Blue Diamond 150 กรัม แพ็ก 2', 'อัลมอนด์เม็ดโตอบกรอบไม่ปรุงรส ไม่ใส่เกลือ ดีต่อสุขภาพ อิ่มท้อง', v_cat_id, 278, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Blue Diamond', 'FDE-0089', '8850000000089', 'แพ็ก 2', 2, array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อัลมอนด์เม็ดโตอบกรอบไม่ปรุงรส ไม่ใส่เกลือ ดีต่อสุขภาพ อิ่มท้อง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Blue Diamond', sku = 'FDE-0089', barcode = '8850000000089', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'สาหร่ายอบกรอบ เถ้าแก่น้อย รสคลาสสิก แพ็ก 12 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สาหร่ายอบกรอบ เถ้าแก่น้อย รสคลาสสิก แพ็ก 12 ซอง', 'สาหร่ายทะเลอบกรอบไม่ทอด ไขมันต่ำ ทานเล่นเพลินๆ แพ็ก 12 ซอง', v_cat_id, 228, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'เถ้าแก่น้อย', 'FDE-0090', '8850000000090', 'แพ็ก 12', 12, array['halal', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สาหร่ายทะเลอบกรอบไม่ทอด ไขมันต่ำ ทานเล่นเพลินๆ แพ็ก 12 ซอง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'เถ้าแก่น้อย', sku = 'FDE-0090', barcode = '8850000000090', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'ข้าวโอ๊ตอบแห้ง Quaker 800 กรัม แพ็ก 2 กระป๋อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ข้าวโอ๊ตอบแห้ง Quaker 800 กรัม แพ็ก 2 กระป๋อง', 'ข้าวโอ๊ตเต็มเมล็ด 100% ใยอาหารสูง ช่วยลดคอเลสเตอรอล ชงทานง่ายใน 3 นาที', v_cat_id, 218, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Quaker', 'FDE-0091', '8850000000091', 'แพ็ก 2', 2, array['halal', 'vegan', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ข้าวโอ๊ตเต็มเมล็ด 100% ใยอาหารสูง ช่วยลดคอเลสเตอรอล ชงทานง่ายใน 3 นาที', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Quaker', sku = 'FDE-0091', barcode = '8850000000091', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'vegan', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'กราโนล่าธัญพืชอบกรอบ รสมิกซ์เบอร์รี่ Diamond Grains 500 ก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กราโนล่าธัญพืชอบกรอบ รสมิกซ์เบอร์รี่ Diamond Grains 500 ก.', 'กราโนล่าไม่ผสมแป้งสาลี ไม่ใส่น้ำตาลขัดสี ทานคู่นมหรือโยเกิร์ตอร่อยมาก', v_cat_id, 229, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Diamond Grains', 'FDE-0092', '8850000000092', 'ถุง', 1, array['halal', 'vegan', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กราโนล่าไม่ผสมแป้งสาลี ไม่ใส่น้ำตาลขัดสี ทานคู่นมหรือโยเกิร์ตอร่อยมาก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Diamond Grains', sku = 'FDE-0092', barcode = '8850000000092', unit = 'ถุง', pack_qty = 1, tags = array['halal', 'vegan', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'มะม่วงอบแห้งไม่เติมน้ำตาล ดอยคำ 140 กรัม แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'มะม่วงอบแห้งไม่เติมน้ำตาล ดอยคำ 140 กรัม แพ็ก 3', 'เนื้อมะม่วงแท้เคี้ยวหนึบ หวานธรรมชาติ ไม่เติมน้ำตาลและไม่ใส่สี', v_cat_id, 267, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'ดอยคำ', 'FDE-0093', '8850000000093', 'แพ็ก 3', 3, array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เนื้อมะม่วงแท้เคี้ยวหนึบ หวานธรรมชาติ ไม่เติมน้ำตาลและไม่ใส่สี', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยคำ', sku = 'FDE-0093', barcode = '8850000000093', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'ดาร์กช็อกโกแลต 70% ไร้น้ำตาล Lindt 100 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ดาร์กช็อกโกแลต 70% ไร้น้ำตาล Lindt 100 กรัม แพ็ก 2', 'ดาร์กช็อกโกแลตเข้มข้นจากสวิตเซอร์แลนด์ รสกลมกล่อมไม่ขมบาดคอ', v_cat_id, 298, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Lindt', 'FDE-0094', '8850000000094', 'แพ็ก 2', 2, array['low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ดาร์กช็อกโกแลตเข้มข้นจากสวิตเซอร์แลนด์ รสกลมกล่อมไม่ขมบาดคอ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Lindt', sku = 'FDE-0094', barcode = '8850000000094', unit = 'แพ็ก 2', pack_qty = 2, tags = array['low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'มันฝรั่งทอดกรอบ เลย์ รสมันฝรั่งแท้ แพ็ก 6 ซองใหญ่' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'มันฝรั่งทอดกรอบ เลย์ รสมันฝรั่งแท้ แพ็ก 6 ซองใหญ่', 'มันฝรั่งแผ่นเรียบรสต้นตำรับ กรอบหอมมัน ปาร์ตี้แพ็ก 6 ซอง', v_cat_id, 168, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 95, 5, true, 'Lay''s', 'FDE-0095', '8850000000095', 'แพ็ก 6', 6, array['halal', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 95, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'มันฝรั่งแผ่นเรียบรสต้นตำรับ กรอบหอมมัน ปาร์ตี้แพ็ก 6 ซอง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Lay''s', sku = 'FDE-0095', barcode = '8850000000095', unit = 'แพ็ก 6', pack_qty = 6, tags = array['halal', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'เม็ดมะม่วงหิมพานต์อบเกลือชมพู 400 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เม็ดมะม่วงหิมพานต์อบเกลือชมพู 400 กรัม', 'เม็ดมะม่วงหิมพานต์เกรด A เต็มเม็ด อบกรอบใหม่ๆ ไม่เหม็นหืน', v_cat_id, 249, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Siam Nut', 'FDE-0096', '8850000000096', 'กระปุก', 1, array['halal', 'vegan', 'no_msg', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เม็ดมะม่วงหิมพานต์เกรด A เต็มเม็ด อบกรอบใหม่ๆ ไม่เหม็นหืน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Siam Nut', sku = 'FDE-0096', barcode = '8850000000096', unit = 'กระปุก', pack_qty = 1, tags = array['halal', 'vegan', 'no_msg', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Healthy Drinks';
    select product_id into v_pid from public.products where name = 'น้ำขิงผงสำเร็จรูป สูตรไม่มีน้ำตาล จินเจน กล่อง 12 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำขิงผงสำเร็จรูป สูตรไม่มีน้ำตาล จินเจน กล่อง 12 ซอง', 'น้ำขิงแท้ 100% รสเผ็ดหอมละมุน ไม่มีน้ำตาล ขับลม ช่วยย่อย ดื่มได้ทุกวัน', v_cat_id, 125, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'จินเจน (Gingen)', 'FDE-0097', '8850000000097', 'กล่อง 12 ซอง', 12, array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำขิงแท้ 100% รสเผ็ดหอมละมุน ไม่มีน้ำตาล ขับลม ช่วยย่อย ดื่มได้ทุกวัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop'), brand = 'จินเจน (Gingen)', sku = 'FDE-0097', barcode = '8850000000097', unit = 'กล่อง 12 ซอง', pack_qty = 12, tags = array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Healthy Drinks';
    select product_id into v_pid from public.products where name = 'น้ำผึ้งดอกลำไยแท้ 100% ดอยคำ 770 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำผึ้งดอกลำไยแท้ 100% ดอยคำ 770 กรัม', 'น้ำผึ้งแท้จากเกสรดอกลำไยภาคเหนือ หอมหวานละมุน มีมาตรฐาน อย.', v_cat_id, 215, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'ดอยคำ', 'FDE-0098', '8850000000098', 'ขวด', 1, array['halal', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำผึ้งแท้จากเกสรดอกลำไยภาคเหนือ หอมหวานละมุน มีมาตรฐาน อย.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยคำ', sku = 'FDE-0098', barcode = '8850000000098', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Healthy Drinks';
    select product_id into v_pid from public.products where name = 'ชาคาโมมายล์ออร์แกนิก Twinings 25 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชาคาโมมายล์ออร์แกนิก Twinings 25 ซอง', 'ชาดอกคาโมมายล์แท้ ไม่มีคาเฟอีน ช่วยผ่อนคลายก่อนนอน', v_cat_id, 195, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Twinings', 'FDE-0099', '8850000000099', 'กล่อง 25 ซอง', 25, array['halal', 'vegan', 'low_sugar', 'organic', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชาดอกคาโมมายล์แท้ ไม่มีคาเฟอีน ช่วยผ่อนคลายก่อนนอน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop'), brand = 'Twinings', sku = 'FDE-0099', barcode = '8850000000099', unit = 'กล่อง 25 ซอง', pack_qty = 25, tags = array['halal', 'vegan', 'low_sugar', 'organic', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Healthy Drinks';
    select product_id into v_pid from public.products where name = 'น้ำแอปเปิ้ลไซเดอร์เวเนการ์ Bragg 473 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำแอปเปิ้ลไซเดอร์เวเนการ์ Bragg 473 มล.', 'Apple Cider Vinegar ออร์แกนิกแท้มี Mother ไม่ผ่านการกรอง ช่วยระบบย่อยอาหาร', v_cat_id, 265, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Bragg', 'FDE-0100', '8850000000100', 'ขวด', 1, array['halal', 'vegan', 'organic', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'Apple Cider Vinegar ออร์แกนิกแท้มี Mother ไม่ผ่านการกรอง ช่วยระบบย่อยอาหาร', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&q=70&auto=format&fit=crop'), brand = 'Bragg', sku = 'FDE-0100', barcode = '8850000000100', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'vegan', 'organic', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'สว่านไขควงไร้สาย Makita 12Vmax DF333DWYE พร้อมแบต 2 ก้อน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สว่านไขควงไร้สาย Makita 12Vmax DF333DWYE พร้อมแบต 2 ก้อน', 'สว่านไร้สายมากิต้าของแท้ ปรับแรงบิด 20 ระดับ มีไฟ LED ส่องสว่าง พร้อมแบต 1.5Ah 2 ก้อนและกล่องหิ้ว', v_cat_id, 3290, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 14, 5, true, 'Makita', 'FDE-0101', '8850000000101', 'ชุด', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 14, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สว่านไร้สายมากิต้าของแท้ ปรับแรงบิด 20 ระดับ มีไฟ LED ส่องสว่าง พร้อมแบต 1.5Ah 2 ก้อนและกล่องหิ้ว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Makita', sku = 'FDE-0101', barcode = '8850000000101', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'สว่านกระแทกไฟฟ้า Bosch GSB 550 550W พร้อมชุดดอกสว่าน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สว่านกระแทกไฟฟ้า Bosch GSB 550 550W พร้อมชุดดอกสว่าน', 'สว่านกระแทกบ๊อช 550 วัตต์ เจาะปูน ไม้ เหล็ก ปรับซ้าย-ขวาได้ ของแท้ประกันศูนย์ 1 ปี', v_cat_id, 1690, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'Bosch', 'FDE-0102', '8850000000102', 'ชุด', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สว่านกระแทกบ๊อช 550 วัตต์ เจาะปูน ไม้ เหล็ก ปรับซ้าย-ขวาได้ ของแท้ประกันศูนย์ 1 ปี', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Bosch', sku = 'FDE-0102', barcode = '8850000000102', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'สว่านไร้สายกระแทก DeWalt 20V DCD778 พร้อมแบตและแท่นชาร์จ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สว่านไร้สายกระแทก DeWalt 20V DCD778 พร้อมแบตและแท่นชาร์จ', 'สว่านไร้สายมอเตอร์ไร้แปรงถ่าน Brushless แรงบิดสูง เจาะคอนกรีตได้สบาย', v_cat_id, 4490, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 9, 5, true, 'DeWalt', 'FDE-0103', '8850000000103', 'ชุด', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 9, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สว่านไร้สายมอเตอร์ไร้แปรงถ่าน Brushless แรงบิดสูง เจาะคอนกรีตได้สบาย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'DeWalt', sku = 'FDE-0103', barcode = '8850000000103', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'สว่านไขควงไร้สาย Pumpkin 12V สำหรับงานช่างในบ้าน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สว่านไขควงไร้สาย Pumpkin 12V สำหรับงานช่างในบ้าน', 'สว่านไร้สายพัมคินราคาคุ้มค่า น้ำหนักเบา ประกอบเฟอร์นิเจอร์และเจาะไม้-เหล็กได้', v_cat_id, 1190, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 26, 5, true, 'Pumpkin', 'FDE-0104', '8850000000104', 'ชุด', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 26, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สว่านไร้สายพัมคินราคาคุ้มค่า น้ำหนักเบา ประกอบเฟอร์นิเจอร์และเจาะไม้-เหล็กได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Pumpkin', sku = 'FDE-0104', barcode = '8850000000104', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'เครื่องเจียรลูกหมู 4 นิ้ว Makita M0910B 540W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องเจียรลูกหมู 4 นิ้ว Makita M0910B 540W', 'หินเจียร 4 นิ้ว มากิต้า ทนงานหนัก จับกระชับมือ มีบังใบนิรภัย', v_cat_id, 1290, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 22, 5, true, 'Makita', 'FDE-0105', '8850000000105', 'เครื่อง', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 22, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หินเจียร 4 นิ้ว มากิต้า ทนงานหนัก จับกระชับมือ มีบังใบนิรภัย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Makita', sku = 'FDE-0105', barcode = '8850000000105', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'เครื่องฉีดน้ำแรงดันสูง Bosch EasyAquatak 120 บาร์' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องฉีดน้ำแรงดันสูง Bosch EasyAquatak 120 บาร์', 'เครื่องฉีดน้ำล้างรถและล้างพื้น แรงดัน 120 บาร์ ประหยัดน้ำ พร้อมหัวฉีดปรับระดับ', v_cat_id, 3190, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Bosch', 'FDE-0106', '8850000000106', 'เครื่อง', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องฉีดน้ำล้างรถและล้างพื้น แรงดัน 120 บาร์ ประหยัดน้ำ พร้อมหัวฉีดปรับระดับ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Bosch', sku = 'FDE-0106', barcode = '8850000000106', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'เครื่องเป่าลมและดูดฝุ่นไฟฟ้า 600W Pumpkin' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องเป่าลมและดูดฝุ่นไฟฟ้า 600W Pumpkin', 'เครื่องเป่าลมแรงสูง ปรับความเร็วได้ 6 ระดับ เป่าใบไม้ เป่าฝุ่นคอมพิวเตอร์และแอร์ได้', v_cat_id, 790, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Pumpkin', 'FDE-0107', '8850000000107', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องเป่าลมแรงสูง ปรับความเร็วได้ 6 ระดับ เป่าใบไม้ เป่าฝุ่นคอมพิวเตอร์และแอร์ได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Pumpkin', sku = 'FDE-0107', barcode = '8850000000107', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'ไขควงไฟฟ้าไร้สายแบบพกพา Bosch Go 3 USB-C' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไขควงไฟฟ้าไร้สายแบบพกพา Bosch Go 3 USB-C', 'ไขควงไฟฟ้าไร้สายขนาดกะทัดรัด กดแล้วหมุนอัตโนมัติ ชาร์จผ่าน USB-C พร้อมชุดดอกไขควง', v_cat_id, 1390, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 19, 5, true, 'Bosch', 'FDE-0108', '8850000000108', 'ชุด', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 19, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไขควงไฟฟ้าไร้สายขนาดกะทัดรัด กดแล้วหมุนอัตโนมัติ ชาร์จผ่าน USB-C พร้อมชุดดอกไขควง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Bosch', sku = 'FDE-0108', barcode = '8850000000108', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'ปืนยิงกาวร้อนไฟฟ้า 60W พร้อมแท่งกาว 12 แท่ง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปืนยิงกาวร้อนไฟฟ้า 60W พร้อมแท่งกาว 12 แท่ง', 'ปืนยิงกาวร้อนเร็วใน 3 นาที เหมาะสำหรับงานประดิษฐ์และซ่อมแซมในบ้าน', v_cat_id, 289, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Stanley', 'FDE-0109', '8850000000109', 'ชุด', 1, array['tis']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปืนยิงกาวร้อนเร็วใน 3 นาที เหมาะสำหรับงานประดิษฐ์และซ่อมแซมในบ้าน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0109', barcode = '8850000000109', unit = 'ชุด', pack_qty = 1, tags = array['tis']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'ชุดเครื่องมือช่างประจำบ้าน Stanley 38 ชิ้น พร้อมกล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดเครื่องมือช่างประจำบ้าน Stanley 38 ชิ้น พร้อมกล่อง', 'ครบชุดค้อน คีม ประแจเลื่อน ไขควง ตลับเมตร และชุดบล็อก เหล็ก Chrome Vanadium แข็งแรง', v_cat_id, 1150, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 24, 5, true, 'Stanley', 'FDE-0110', '8850000000110', 'ชุด 38 ชิ้น', 38, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 24, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ครบชุดค้อน คีม ประแจเลื่อน ไขควง ตลับเมตร และชุดบล็อก เหล็ก Chrome Vanadium แข็งแรง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0110', barcode = '8850000000110', unit = 'ชุด 38 ชิ้น', pack_qty = 38, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'ตลับเมตรหุ้มยาง Stanley 5 เมตร หน่วย มม./นิ้ว' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ตลับเมตรหุ้มยาง Stanley 5 เมตร หน่วย มม./นิ้ว', 'ตลับเมตรสแตนเลย์ใบเคลือบไนลอนไม่เป็นสนิม อ่านค่าง่าย ทนตกกระแทก', v_cat_id, 195, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Stanley', 'FDE-0111', '8850000000111', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ตลับเมตรสแตนเลย์ใบเคลือบไนลอนไม่เป็นสนิม อ่านค่าง่าย ทนตกกระแทก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0111', barcode = '8850000000111', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'ชุดประแจแหวนข้างปากตาย 14 ตัวชุด เบอร์ 8-24 มม.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดประแจแหวนข้างปากตาย 14 ตัวชุด เบอร์ 8-24 มม.', 'ประแจเหล็ก CR-V ชุบโครเมียมด้าน ไม่รูดง่าย พร้อมซองผ้าม้วนเก็บ', v_cat_id, 990, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'King Tony', 'FDE-0112', '8850000000112', 'ชุด 14 ชิ้น', 14, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ประแจเหล็ก CR-V ชุบโครเมียมด้าน ไม่รูดง่าย พร้อมซองผ้าม้วนเก็บ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'King Tony', sku = 'FDE-0112', barcode = '8850000000112', unit = 'ชุด 14 ชิ้น', pack_qty = 14, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'คีมล็อกปากโค้ง 10 นิ้ว Irwin Vise-Grip ของแท้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คีมล็อกปากโค้ง 10 นิ้ว Irwin Vise-Grip ของแท้', 'คีมล็อกจับชิ้นงานแน่นไม่ลื่นหลุด เหล็กกล้าอัลลอยทนทานสูง', v_cat_id, 420, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Irwin', 'FDE-0113', '8850000000113', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'คีมล็อกจับชิ้นงานแน่นไม่ลื่นหลุด เหล็กกล้าอัลลอยทนทานสูง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Irwin', sku = 'FDE-0113', barcode = '8850000000113', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'คัตเตอร์ใบมีดคมพิเศษ Olfa L-1 18 มม. พร้อมใบสำรอง 5 ใบ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คัตเตอร์ใบมีดคมพิเศษ Olfa L-1 18 มม. พร้อมใบสำรอง 5 ใบ', 'มีดคัตเตอร์ญี่ปุ่นแท้ ตัวล็อกแบบหมุนปลอดภัย ตัดกล่องและงานช่างได้คมกริบ', v_cat_id, 165, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'Olfa', 'FDE-0114', '8850000000114', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'มีดคัตเตอร์ญี่ปุ่นแท้ ตัวล็อกแบบหมุนปลอดภัย ตัดกล่องและงานช่างได้คมกริบ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Olfa', sku = 'FDE-0114', barcode = '8850000000114', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'บันไดอะลูมิเนียมทรงเอ 5 ขั้น รับน้ำหนัก 150 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'บันไดอะลูมิเนียมทรงเอ 5 ขั้น รับน้ำหนัก 150 กก.', 'บันไดอะลูมิเนียมหนา น้ำหนักเบาไม่เป็นสนิม มียางกันลื่นที่ขาทั้ง 4 ด้าน', v_cat_id, 1490, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Barco', 'FDE-0115', '8850000000115', 'ตัว', 1, array['tis']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'บันไดอะลูมิเนียมหนา น้ำหนักเบาไม่เป็นสนิม มียางกันลื่นที่ขาทั้ง 4 ด้าน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Barco', sku = 'FDE-0115', barcode = '8850000000115', unit = 'ตัว', pack_qty = 1, tags = array['tis']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'กล่องเครื่องมือพลาสติกเหนียว 19 นิ้ว ถาด 2 ชั้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล่องเครื่องมือพลาสติกเหนียว 19 นิ้ว ถาด 2 ชั้น', 'กล่องใส่เครื่องมือช่างหูหิ้วแข็งแรง ตัวล็อกโลหะไม่หักง่าย', v_cat_id, 450, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Stanley', 'FDE-0116', '8850000000116', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล่องใส่เครื่องมือช่างหูหิ้วแข็งแรง ตัวล็อกโลหะไม่หักง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0116', barcode = '8850000000116', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'ซิลิโคนยาแนวกันเชื้อราห้องน้ำสีขาว 280 มล. แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซิลิโคนยาแนวกันเชื้อราห้องน้ำสีขาว 280 มล. แพ็ก 2', 'ซิลิโคนยาแนวคุณภาพสูง ป้องกันน้ำรั่วและเชื้อราในห้องน้ำและซิงค์ล้างจาน', v_cat_id, 210, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'TOA', 'FDE-0117', '8850000000117', 'แพ็ก 2', 2, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซิลิโคนยาแนวคุณภาพสูง ป้องกันน้ำรั่วและเชื้อราในห้องน้ำและซิงค์ล้างจาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'TOA', sku = 'FDE-0117', barcode = '8850000000117', unit = 'แพ็ก 2', pack_qty = 2, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'เทปกาวสองหน้าแรงยึดสูง 3M VHB 19 มม. ยาว 4 เมตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เทปกาวสองหน้าแรงยึดสูง 3M VHB 19 มม. ยาว 4 เมตร', 'เทปกาวอะคริลิคโฟมแรงยึดสูง ติดผนังปูน กระเบื้อง กระจก และรถยนต์โดยไม่ต้องเจาะ', v_cat_id, 185, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 70, 5, true, '3M', 'FDE-0118', '8850000000118', 'ม้วน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เทปกาวอะคริลิคโฟมแรงยึดสูง ติดผนังปูน กระเบื้อง กระจก และรถยนต์โดยไม่ต้องเจาะ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0118', barcode = '8850000000118', unit = 'ม้วน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ลูกบิดประตูสแตนเลส 304 Hafele ไส้ทองเหลือง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ลูกบิดประตูสแตนเลส 304 Hafele ไส้ทองเหลือง', 'ลูกบิดประตูเฮเฟเล่สแตนเลสแท้ไม่เป็นสนิม ระบบกุญแจ 5 พิน พร้อมลูกกุญแจ 3 ดอก', v_cat_id, 349, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Hafele', 'FDE-0119', '8850000000119', 'ชุด', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ลูกบิดประตูเฮเฟเล่สแตนเลสแท้ไม่เป็นสนิม ระบบกุญแจ 5 พิน พร้อมลูกกุญแจ 3 ดอก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Hafele', sku = 'FDE-0119', barcode = '8850000000119', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ก๊อกอ่างล้างหน้าสแตนเลส 304 วาล์วเซรามิก COTTO' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ก๊อกอ่างล้างหน้าสแตนเลส 304 วาล์วเซรามิก COTTO', 'ก๊อกน้ำสแตนเลสไร้สารตะกั่ว ไม่เป็นสนิม น้ำนุ่มไม่กระเด็น ผ่าน มอก.', v_cat_id, 590, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'COTTO', 'FDE-0120', '8850000000120', 'ชิ้น', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ก๊อกน้ำสแตนเลสไร้สารตะกั่ว ไม่เป็นสนิม น้ำนุ่มไม่กระเด็น ผ่าน มอก.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'COTTO', sku = 'FDE-0120', barcode = '8850000000120', unit = 'ชิ้น', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ชุดสายฉีดชำระสแตนเลส 304 พร้อมสาย 1.2 เมตร Hafele' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดสายฉีดชำระสแตนเลส 304 พร้อมสาย 1.2 เมตร Hafele', 'สายฉีดชำระแรงดันนุ่มไม่บาดผิว ก้านกดแข็งแรงไม่หักง่าย สายถักไม่บิดงอ', v_cat_id, 289, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Hafele', 'FDE-0121', '8850000000121', 'ชุด', 1, array['tis', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สายฉีดชำระแรงดันนุ่มไม่บาดผิว ก้านกดแข็งแรงไม่หักง่าย สายถักไม่บิดงอ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Hafele', sku = 'FDE-0121', barcode = '8850000000121', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ฝักบัวอาบน้ำเพิ่มแรงดันน้ำพร้อมไส้กรองคลอรีน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ฝักบัวอาบน้ำเพิ่มแรงดันน้ำพร้อมไส้กรองคลอรีน', 'หัวฝักบัวรูละเอียดช่วยประหยัดน้ำ 30% พร้อมหินกรองตะกอนและคลอรีน', v_cat_id, 390, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 42, 5, true, 'COTTO', 'FDE-0122', '8850000000122', 'ชุด', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 42, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หัวฝักบัวรูละเอียดช่วยประหยัดน้ำ 30% พร้อมหินกรองตะกอนและคลอรีน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'COTTO', sku = 'FDE-0122', barcode = '8850000000122', unit = 'ชุด', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'หลอดไฟ LED ขั้ว E27 แสงขาว Daylight 12W Philips แพ็ก 4' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หลอดไฟ LED ขั้ว E27 แสงขาว Daylight 12W Philips แพ็ก 4', 'หลอดไฟ LED ประหยัดไฟ 85% ถนอมสายตา EyeComfort อายุการใช้งาน 15,000 ชม.', v_cat_id, 279, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'Philips', 'FDE-0123', '8850000000123', 'แพ็ก 4', 4, array['tis', 'eco', 'wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หลอดไฟ LED ประหยัดไฟ 85% ถนอมสายตา EyeComfort อายุการใช้งาน 15,000 ชม.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Philips', sku = 'FDE-0123', barcode = '8850000000123', unit = 'แพ็ก 4', pack_qty = 4, tags = array['tis', 'eco', 'wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'เทปพันสายไฟ 3M Temflex 1710 สีดำ แพ็ก 5 ม้วน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เทปพันสายไฟ 3M Temflex 1710 สีดำ แพ็ก 5 ม้วน', 'เทปพันสายไฟไม่ลามไฟ เนื้อกาวไม่เยิ้ม ทนแรงดันไฟฟ้า 600V', v_cat_id, 125, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 110, 5, true, '3M', 'FDE-0124', '8850000000124', 'แพ็ก 5', 5, array['tis', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 110, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เทปพันสายไฟไม่ลามไฟ เนื้อกาวไม่เยิ้ม ทนแรงดันไฟฟ้า 600V', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0124', barcode = '8850000000124', unit = 'แพ็ก 5', pack_qty = 5, tags = array['tis', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ไขควงวัดไฟดิจิทัลเช็คสายขาดในได้ ไม่ต้องสัมผัส' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไขควงวัดไฟดิจิทัลเช็คสายขาดในได้ ไม่ต้องสัมผัส', 'ปากกาวัดไฟไร้สัมผัส แจ้งเตือนด้วยเสียงและไฟ LED ตรวจสายไฟขาดในได้แม่นยำ', v_cat_id, 249, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Stanley', 'FDE-0125', '8850000000125', 'อัน', 1, array['tis']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปากกาวัดไฟไร้สัมผัส แจ้งเตือนด้วยเสียงและไฟ LED ตรวจสายไฟขาดในได้แม่นยำ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0125', barcode = '8850000000125', unit = 'อัน', pack_qty = 1, tags = array['tis']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'สเปรย์หล่อลื่นไล่ความชื้นกันสนิม WD-40 400 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สเปรย์หล่อลื่นไล่ความชื้นกันสนิม WD-40 400 มล.', 'สเปรย์อเนกประสงค์คลายน็อตที่เป็นสนิม หล่อลื่นบานพับ และไล่ความชื้นระบบไฟฟ้า', v_cat_id, 215, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'WD-40', 'FDE-0126', '8850000000126', 'กระป๋อง', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สเปรย์อเนกประสงค์คลายน็อตที่เป็นสนิม หล่อลื่นบานพับ และไล่ความชื้นระบบไฟฟ้า', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'WD-40', sku = 'FDE-0126', barcode = '8850000000126', unit = 'กระป๋อง', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Gardening';
    select product_id into v_pid from public.products where name = 'สายยางรดน้ำต้นไม้ใยเชือกสีฟ้า 5/8 นิ้ว ยาว 20 เมตร พร้อมหัวฉีด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สายยางรดน้ำต้นไม้ใยเชือกสีฟ้า 5/8 นิ้ว ยาว 20 เมตร พร้อมหัวฉีด', 'สายยางเด้งไม่พับงอ ไม่เกิดตะไคร่น้ำ ทนแดดเมืองไทย พร้อมหัวฉีดปรับน้ำ 7 แบบ', v_cat_id, 450, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'SCG', 'FDE-0127', '8850000000127', 'ม้วน 20 ม.', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สายยางเด้งไม่พับงอ ไม่เกิดตะไคร่น้ำ ทนแดดเมืองไทย พร้อมหัวฉีดปรับน้ำ 7 แบบ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop'), brand = 'SCG', sku = 'FDE-0127', barcode = '8850000000127', unit = 'ม้วน 20 ม.', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Gardening';
    select product_id into v_pid from public.products where name = 'กรรไกรตัดกิ่งไม้ปากโค้ง 8 นิ้ว ใบเหล็ก SK-5 Pumpkin' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กรรไกรตัดกิ่งไม้ปากโค้ง 8 นิ้ว ใบเหล็ก SK-5 Pumpkin', 'กรรไกรตัดกิ่งคมกริบ ตัดกิ่งหนาได้ถึง 20 มม. มีสปริงช่วยผ่อนแรง', v_cat_id, 259, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Pumpkin', 'FDE-0128', '8850000000128', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กรรไกรตัดกิ่งคมกริบ ตัดกิ่งหนาได้ถึง 20 มม. มีสปริงช่วยผ่อนแรง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop'), brand = 'Pumpkin', sku = 'FDE-0128', barcode = '8850000000128', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Gardening';
    select product_id into v_pid from public.products where name = 'ดินปลูกต้นไม้ผสมมูลไส้เดือนออร์แกนิก 5 กก. แพ็ก 3 ถุง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ดินปลูกต้นไม้ผสมมูลไส้เดือนออร์แกนิก 5 กก. แพ็ก 3 ถุง', 'ดินร่วนซุยระบายน้ำดี อุดมธาตุอาหารสำหรับไม้ใบ ไม้ดอก และผักสวนครัว', v_cat_id, 165, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'GreenGrow', 'FDE-0129', '8850000000129', 'แพ็ก 3', 3, array['organic', 'eco', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ดินร่วนซุยระบายน้ำดี อุดมธาตุอาหารสำหรับไม้ใบ ไม้ดอก และผักสวนครัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop'), brand = 'GreenGrow', sku = 'FDE-0129', barcode = '8850000000129', unit = 'แพ็ก 3', pack_qty = 3, tags = array['organic', 'eco', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Gardening';
    select product_id into v_pid from public.products where name = 'ชุดอุปกรณ์ทำสวน 3 ชิ้น พลั่ว ส้อมพรวน ด้ามยางกันลื่น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดอุปกรณ์ทำสวน 3 ชิ้น พลั่ว ส้อมพรวน ด้ามยางกันลื่น', 'ชุดปลูกต้นไม้สแตนเลสหนา ไม่หักงอ เหมาะสำหรับสวนระเบียงและบ้าน', v_cat_id, 229, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Stanley', 'FDE-0130', '8850000000130', 'ชุด 3 ชิ้น', 3, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดปลูกต้นไม้สแตนเลสหนา ไม่หักงอ เหมาะสำหรับสวนระเบียงและบ้าน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0130', barcode = '8850000000130', unit = 'ชุด 3 ชิ้น', pack_qty = 3, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Car Care';
    select product_id into v_pid from public.products where name = 'แชมพูล้างรถผสมแว็กซ์ 3M 1000 มล. แถมผ้าไมโครไฟเบอร์' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แชมพูล้างรถผสมแว็กซ์ 3M 1000 มล. แถมผ้าไมโครไฟเบอร์', 'แชมพูล้างรถสูตร pH-Neutral ไม่ทำลายชั้นเคลือบสี เงางามทันทีหลังล้าง', v_cat_id, 229, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop', 50, 5, true, '3M', 'FDE-0131', '8850000000131', 'ขวด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แชมพูล้างรถสูตร pH-Neutral ไม่ทำลายชั้นเคลือบสี เงางามทันทีหลังล้าง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0131', barcode = '8850000000131', unit = 'ขวด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Car Care';
    select product_id into v_pid from public.products where name = 'ผ้าไมโครไฟเบอร์เช็ดรถหนานุ่ม 600 GSM แพ็ก 3 ผืน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ผ้าไมโครไฟเบอร์เช็ดรถหนานุ่ม 600 GSM แพ็ก 3 ผืน', 'ผ้าเช็ดรถไม่ทิ้งขน ไม่ทำให้เกิดรอยขนแมว ซับน้ำได้มากเป็นพิเศษ', v_cat_id, 189, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop', 75, 5, true, '3M', 'FDE-0132', '8850000000132', 'แพ็ก 3', 3, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าเช็ดรถไม่ทิ้งขน ไม่ทำให้เกิดรอยขนแมว ซับน้ำได้มากเป็นพิเศษ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0132', barcode = '8850000000132', unit = 'แพ็ก 3', pack_qty = 3, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Car Care';
    select product_id into v_pid from public.products where name = 'ปั๊มลมยางรถยนต์ไร้สายดิจิทัล ตั้งค่าแรงดันตัดอัตโนมัติ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปั๊มลมยางรถยนต์ไร้สายดิจิทัล ตั้งค่าแรงดันตัดอัตโนมัติ', 'เครื่องสูบลมยางพกพา เติมลมรถยนต์ มอเตอร์ไซค์ จักรยาน และลูกบอล ชาร์จ USB-C', v_cat_id, 1190, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop', 22, 5, true, 'Xiaomi', 'FDE-0133', '8850000000133', 'เครื่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 22, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องสูบลมยางพกพา เติมลมรถยนต์ มอเตอร์ไซค์ จักรยาน และลูกบอล ชาร์จ USB-C', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop'), brand = 'Xiaomi', sku = 'FDE-0133', barcode = '8850000000133', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Car Care';
    select product_id into v_pid from public.products where name = 'กล้องติดรถยนต์หน้า-หลัง 2K Wi-Fi 70mai A500S' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล้องติดรถยนต์หน้า-หลัง 2K Wi-Fi 70mai A500S', 'กล้องติดรถภาพคมชัดกลางคืน มี GPS บันทึกความเร็ว ดูคลิปผ่านมือถือได้ทันที', v_cat_id, 2590, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop', 15, 5, true, '70mai', 'FDE-0134', '8850000000134', 'ชุด', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 15, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล้องติดรถภาพคมชัดกลางคืน มี GPS บันทึกความเร็ว ดูคลิปผ่านมือถือได้ทันที', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop'), brand = '70mai', sku = 'FDE-0134', barcode = '8850000000134', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Lighting & Solar';
    select product_id into v_pid from public.products where name = 'ไฟโซลาร์เซลล์ติดผนัง 100 LED เซ็นเซอร์จับความเคลื่อนไหว แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไฟโซลาร์เซลล์ติดผนัง 100 LED เซ็นเซอร์จับความเคลื่อนไหว แพ็ก 2', 'โคมไฟพลังงานแสงอาทิตย์กันน้ำ IP65 เปิดเองตอนกลางคืน ประหยัดค่าไฟ 0 บาท', v_cat_id, 349, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Modi', 'FDE-0135', '8850000000135', 'แพ็ก 2', 2, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โคมไฟพลังงานแสงอาทิตย์กันน้ำ IP65 เปิดเองตอนกลางคืน ประหยัดค่าไฟ 0 บาท', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop'), brand = 'Modi', sku = 'FDE-0135', barcode = '8850000000135', unit = 'แพ็ก 2', pack_qty = 2, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Lighting & Solar';
    select product_id into v_pid from public.products where name = 'สปอร์ตไลท์โซลาร์เซลล์ 200W พร้อมแผงและรีโมท' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สปอร์ตไลท์โซลาร์เซลล์ 200W พร้อมแผงและรีโมท', 'ไฟส่องสว่างลานบ้านและโรงรถ สว่างยันเช้า กันฝน IP67 ติดตั้งง่ายไม่ต้องเดินสายไฟ', v_cat_id, 790, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'Modi', 'FDE-0136', '8850000000136', 'ชุด', 1, array['eco', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไฟส่องสว่างลานบ้านและโรงรถ สว่างยันเช้า กันฝน IP67 ติดตั้งง่ายไม่ต้องเดินสายไฟ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop'), brand = 'Modi', sku = 'FDE-0136', barcode = '8850000000136', unit = 'ชุด', pack_qty = 1, tags = array['eco', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Lighting & Solar';
    select product_id into v_pid from public.products where name = 'ไฟฉายแรงสูง LED ชาร์จ USB-C ซูมได้ กันน้ำ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไฟฉายแรงสูง LED ชาร์จ USB-C ซูมได้ กันน้ำ', 'ไฟฉายอะลูมิเนียมเกรดการบิน ส่องไกล 300 เมตร ปรับไฟได้ 5 โหมด พกติดรถหรือเข้าแคมป์', v_cat_id, 290, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Chang Pro', 'FDE-0137', '8850000000137', 'กระบอก', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไฟฉายอะลูมิเนียมเกรดการบิน ส่องไกล 300 เมตร ปรับไฟได้ 5 โหมด พกติดรถหรือเข้าแคมป์', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=70&auto=format&fit=crop'), brand = 'Chang Pro', sku = 'FDE-0137', barcode = '8850000000137', unit = 'กระบอก', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'กระเป๋าเป้โน้ตบุ๊กกันน้ำ 15.6 นิ้ว มีช่อง USB' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระเป๋าเป้โน้ตบุ๊กกันน้ำ 15.6 นิ้ว มีช่อง USB', 'กระเป๋าเป้ทำงานและเดินทาง ผ้า Oxford กันละอองน้ำ ช่องบุกันกระแทกโน้ตบุ๊ก 15.6 นิ้ว', v_cat_id, 790, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'Urban Fit', 'FDE-0138', '8850000000138', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระเป๋าเป้ทำงานและเดินทาง ผ้า Oxford กันละอองน้ำ ช่องบุกันกระแทกโน้ตบุ๊ก 15.6 นิ้ว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0138', barcode = '8850000000138', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'กระเป๋าสะพายข้าง Crossbody ไนลอนกันน้ำ มินิมอล' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระเป๋าสะพายข้าง Crossbody ไนลอนกันน้ำ มินิมอล', 'กระเป๋าสะพายพาดลำตัวน้ำหนักเบา ช่องเก็บของเป็นสัดส่วน ใส่ iPad mini และมือถือได้', v_cat_id, 390, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Urban Fit', 'FDE-0139', '8850000000139', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระเป๋าสะพายพาดลำตัวน้ำหนักเบา ช่องเก็บของเป็นสัดส่วน ใส่ iPad mini และมือถือได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0139', barcode = '8850000000139', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'กระเป๋าเดินทางล้อลาก 20 นิ้ว PC+ABS ขึ้นเครื่องได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระเป๋าเดินทางล้อลาก 20 นิ้ว PC+ABS ขึ้นเครื่องได้', 'กระเป๋าเดินทางขนาด Carry-on ล้อคู่หมุน 360 องศาเงียบกริบ ตัวล็อกรหัส TSA', v_cat_id, 1590, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 16, 5, true, 'Urban Fit', 'FDE-0140', '8850000000140', 'ใบ', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 16, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระเป๋าเดินทางขนาด Carry-on ล้อคู่หมุน 360 องศาเงียบกริบ ตัวล็อกรหัส TSA', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0140', barcode = '8850000000140', unit = 'ใบ', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'หมวกแก๊ปผ้าคอตตอนกันยูวี ปรับสายได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หมวกแก๊ปผ้าคอตตอนกันยูวี ปรับสายได้', 'หมวกแก๊ปทรงสวยระบายอากาศดี ใส่เดินเที่ยวหรือวิ่งออกกำลังกาย', v_cat_id, 220, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Urban Fit', 'FDE-0141', '8850000000141', 'ใบ', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หมวกแก๊ปทรงสวยระบายอากาศดี ใส่เดินเที่ยวหรือวิ่งออกกำลังกาย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0141', barcode = '8850000000141', unit = 'ใบ', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Apparel';
    select product_id into v_pid from public.products where name = 'เสื้อยืดคอตตอนแท้ 100% Super Soft สีขาว/ดำ แพ็ก 2 ตัว' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เสื้อยืดคอตตอนแท้ 100% Super Soft สีขาว/ดำ แพ็ก 2 ตัว', 'เสื้อยืดผ้าคอตตอน Comb 32 นุ่มสบาย ไม่หด ไม่ย้วย ระบายอากาศดีเยี่ยม', v_cat_id, 390, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'Urban Fit', 'FDE-0142', '8850000000142', 'แพ็ก 2', 2, array['bestseller', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เสื้อยืดผ้าคอตตอน Comb 32 นุ่มสบาย ไม่หด ไม่ย้วย ระบายอากาศดีเยี่ยม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0142', barcode = '8850000000142', unit = 'แพ็ก 2', pack_qty = 2, tags = array['bestseller', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Apparel';
    select product_id into v_pid from public.products where name = 'เสื้อโปโลผ้า Dry-Tech ระบายเหงื่อไม่เหม็นอับ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เสื้อโปโลผ้า Dry-Tech ระบายเหงื่อไม่เหม็นอับ', 'เสื้อโปโลทำงานทรงสมาร์ท ไม่ต้องรีด แห้งไว ใส่สบายทั้งวัน', v_cat_id, 350, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Urban Fit', 'FDE-0143', '8850000000143', 'ตัว', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เสื้อโปโลทำงานทรงสมาร์ท ไม่ต้องรีด แห้งไว ใส่สบายทั้งวัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0143', barcode = '8850000000143', unit = 'ตัว', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Apparel';
    select product_id into v_pid from public.products where name = 'เสื้อคลุมกันแดด UV Protection UPF50+ น้ำหนักเบา' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เสื้อคลุมกันแดด UV Protection UPF50+ น้ำหนักเบา', 'เสื้อแจ็คเก็ตกันแดดพับเก็บใส่กระเป๋าเล็กได้ ระบายความร้อนดี ใส่ขับรถหรือเดินกลางแจ้ง', v_cat_id, 490, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Urban Fit', 'FDE-0144', '8850000000144', 'ตัว', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เสื้อแจ็คเก็ตกันแดดพับเก็บใส่กระเป๋าเล็กได้ ระบายความร้อนดี ใส่ขับรถหรือเดินกลางแจ้ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0144', barcode = '8850000000144', unit = 'ตัว', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Apparel';
    select product_id into v_pid from public.products where name = 'กางเกงขาสั้นวิ่งออกกำลังกายแห้งไว มีกระเป๋าซิป' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กางเกงขาสั้นวิ่งออกกำลังกายแห้งไว มีกระเป๋าซิป', 'กางเกงกีฬาผ้ายืด 4 ทิศทาง น้ำหนักเบา ซับในระบายอากาศ กระเป๋าซิปใส่มือถือไม่หล่น', v_cat_id, 290, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Urban Fit', 'FDE-0145', '8850000000145', 'ตัว', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กางเกงกีฬาผ้ายืด 4 ทิศทาง น้ำหนักเบา ซับในระบายอากาศ กระเป๋าซิปใส่มือถือไม่หล่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0145', barcode = '8850000000145', unit = 'ตัว', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Apparel';
    select product_id into v_pid from public.products where name = 'ถุงเท้ากีฬาหนานุ่มกันเสียดสี แพ็ก 5 คู่' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ถุงเท้ากีฬาหนานุ่มกันเสียดสี แพ็ก 5 คู่', 'ถุงเท้าคอตตอนผสมสแปนเด็กซ์ รองรับแรงกระแทก ลดกลิ่นอับ แพ็ก 5 คู่คุ้มมาก', v_cat_id, 199, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop', 95, 5, true, 'Urban Fit', 'FDE-0146', '8850000000146', 'แพ็ก 5 คู่', 5, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 95, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ถุงเท้าคอตตอนผสมสแปนเด็กซ์ รองรับแรงกระแทก ลดกลิ่นอับ แพ็ก 5 คู่คุ้มมาก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0146', barcode = '8850000000146', unit = 'แพ็ก 5 คู่', pack_qty = 5, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Footwear';
    select product_id into v_pid from public.products where name = 'รองเท้าวิ่งพื้นโฟมนุ่มซัพพอร์ตข้อเท้า' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'รองเท้าวิ่งพื้นโฟมนุ่มซัพพอร์ตข้อเท้า', 'รองเท้าวิ่งหน้าผ้าตาข่ายระบายอากาศ พื้น EVA เด้งนุ่ม ใส่วิ่งและเดินเที่ยวสบายทั้งวัน', v_cat_id, 1290, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop', 24, 5, true, 'Urban Fit', 'FDE-0147', '8850000000147', 'คู่', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 24, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'รองเท้าวิ่งหน้าผ้าตาข่ายระบายอากาศ พื้น EVA เด้งนุ่ม ใส่วิ่งและเดินเที่ยวสบายทั้งวัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0147', barcode = '8850000000147', unit = 'คู่', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Footwear';
    select product_id into v_pid from public.products where name = 'รองเท้าแตะเพื่อสุขภาพพื้นหนานุ่มกันลื่น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'รองเท้าแตะเพื่อสุขภาพพื้นหนานุ่มกันลื่น', 'รองเท้าแตะ EVA รองรับอุ้งเท้า ลดอาการเมื่อยส้นเท้า ใส่ในบ้านและนอกบ้านได้', v_cat_id, 259, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Urban Fit', 'FDE-0148', '8850000000148', 'คู่', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'รองเท้าแตะ EVA รองรับอุ้งเท้า ลดอาการเมื่อยส้นเท้า ใส่ในบ้านและนอกบ้านได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0148', barcode = '8850000000148', unit = 'คู่', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Footwear';
    select product_id into v_pid from public.products where name = 'รองเท้าผ้าใบสลิปออนสีขาวมินิมอล สวมง่าย' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'รองเท้าผ้าใบสลิปออนสีขาวมินิมอล สวมง่าย', 'รองเท้าลำลองแมตช์ง่ายกับทุกชุด พื้นยางกันลื่นน้ำหนักเบา', v_cat_id, 690, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop', 32, 5, true, 'Urban Fit', 'FDE-0149', '8850000000149', 'คู่', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 32, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'รองเท้าลำลองแมตช์ง่ายกับทุกชุด พื้นยางกันลื่นน้ำหนักเบา', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0149', barcode = '8850000000149', unit = 'คู่', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'เสื่อโยคะ TPE กันลื่น 2 หน้า หนา 8 มม. พร้อมสายสะพาย' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เสื่อโยคะ TPE กันลื่น 2 หน้า หนา 8 มม. พร้อมสายสะพาย', 'เสื่อโยคะวัสดุ TPE เป็นมิตรกับสิ่งแวดล้อม ไร้กลิ่นเหม็น นุ่มรองรับเข่าและข้อศอกได้ดี', v_cat_id, 490, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'FitPro', 'FDE-0150', '8850000000150', 'ผืน', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เสื่อโยคะวัสดุ TPE เป็นมิตรกับสิ่งแวดล้อม ไร้กลิ่นเหม็น นุ่มรองรับเข่าและข้อศอกได้ดี', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0150', barcode = '8850000000150', unit = 'ผืน', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'ดัมเบลหุ้มยาง 5 กก. แพ็กคู่ (รวม 10 กก.)' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ดัมเบลหุ้มยาง 5 กก. แพ็กคู่ (รวม 10 กก.)', 'ดัมเบลทรงหกเหลี่ยมไม่กลิ้ง หุ้มยางกันพื้นเป็นรอย จับกระชับไม่ลื่นเหงื่อ', v_cat_id, 790, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'FitPro', 'FDE-0151', '8850000000151', 'คู่ 2 ชิ้น', 2, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ดัมเบลทรงหกเหลี่ยมไม่กลิ้ง หุ้มยางกันพื้นเป็นรอย จับกระชับไม่ลื่นเหงื่อ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0151', barcode = '8850000000151', unit = 'คู่ 2 ชิ้น', pack_qty = 2, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'ยางยืดออกกำลังกาย Resistance Band ชุด 5 ระดับแรงต้าน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ยางยืดออกกำลังกาย Resistance Band ชุด 5 ระดับแรงต้าน', 'ยางยืดเวทเทรนนิ่งและยืดเหยียด 5 ระดับ ตั้งแต่เบาถึงหนัก พกไปออกกำลังกายได้ทุกที่', v_cat_id, 249, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'FitPro', 'FDE-0152', '8850000000152', 'ชุด 5 เส้น', 5, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ยางยืดเวทเทรนนิ่งและยืดเหยียด 5 ระดับ ตั้งแต่เบาถึงหนัก พกไปออกกำลังกายได้ทุกที่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0152', barcode = '8850000000152', unit = 'ชุด 5 เส้น', pack_qty = 5, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'เชือกกระโดดแบบลูกปืนหมุนลื่น นับรอบอัตโนมัติ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เชือกกระโดดแบบลูกปืนหมุนลื่น นับรอบอัตโนมัติ', 'เชือกกระโดดคาร์ดิโอปรับความยาวได้ ด้ามจับโฟมกันลื่น เบิร์นไขมันไว', v_cat_id, 199, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'FitPro', 'FDE-0153', '8850000000153', 'เส้น', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เชือกกระโดดคาร์ดิโอปรับความยาวได้ ด้ามจับโฟมกันลื่น เบิร์นไขมันไว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0153', barcode = '8850000000153', unit = 'เส้น', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'ลูกกลิ้งบริหารหน้าท้อง AB Wheel แบบเด้งกลับอัตโนมัติ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ลูกกลิ้งบริหารหน้าท้อง AB Wheel แบบเด้งกลับอัตโนมัติ', 'ล้อหน้าท้องรุ่น Auto-Rebound ล้อกว้างทรงตัวง่าย แถมแผ่นรองเข่า', v_cat_id, 390, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'FitPro', 'FDE-0154', '8850000000154', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ล้อหน้าท้องรุ่น Auto-Rebound ล้อกว้างทรงตัวง่าย แถมแผ่นรองเข่า', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0154', barcode = '8850000000154', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bottles & Hydration';
    select product_id into v_pid from public.products where name = 'แก้วเก็บความเย็นสแตนเลส 304 ขนาด 900 มล. เก็บน้ำแข็ง 18 ชม.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แก้วเก็บความเย็นสแตนเลส 304 ขนาด 900 มล. เก็บน้ำแข็ง 18 ชม.', 'แก้วเก็บอุณหภูมิร้อน-เย็น ไม่มีไอน้ำเกาะข้างแก้ว วางช่องวางแก้วรถยนต์ได้', v_cat_id, 359, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'HydroThai', 'FDE-0155', '8850000000155', 'ใบ', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แก้วเก็บอุณหภูมิร้อน-เย็น ไม่มีไอน้ำเกาะข้างแก้ว วางช่องวางแก้วรถยนต์ได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop'), brand = 'HydroThai', sku = 'FDE-0155', barcode = '8850000000155', unit = 'ใบ', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bottles & Hydration';
    select product_id into v_pid from public.products where name = 'ขวดน้ำบอกเวลาดื่ม 2 ลิตร BPA-Free พร้อมหลอดเด้ง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ขวดน้ำบอกเวลาดื่ม 2 ลิตร BPA-Free พร้อมหลอดเด้ง', 'ขวดน้ำพลาสติก Tritan ปลอดภัย 100% มีสเกลเตือนเวลาดื่มน้ำครบวันละ 2 ลิตร', v_cat_id, 189, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'HydroThai', 'FDE-0156', '8850000000156', 'ขวด', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขวดน้ำพลาสติก Tritan ปลอดภัย 100% มีสเกลเตือนเวลาดื่มน้ำครบวันละ 2 ลิตร', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop'), brand = 'HydroThai', sku = 'FDE-0156', barcode = '8850000000156', unit = 'ขวด', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bottles & Hydration';
    select product_id into v_pid from public.products where name = 'กระติกน้ำสุญญากาศเก็บความเย็น LocknLock 500 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระติกน้ำสุญญากาศเก็บความเย็น LocknLock 500 มล.', 'กระติกน้ำพกพาน้ำหนักเบา เก็บเย็น-ร้อนยาวนาน ฝาปิดสนิทไม่หกในกระเป๋า', v_cat_id, 490, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'LocknLock', 'FDE-0157', '8850000000157', 'ใบ', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระติกน้ำพกพาน้ำหนักเบา เก็บเย็น-ร้อนยาวนาน ฝาปิดสนิทไม่หกในกระเป๋า', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600&q=70&auto=format&fit=crop'), brand = 'LocknLock', sku = 'FDE-0157', barcode = '8850000000157', unit = 'ใบ', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Camping & Outdoor';
    select product_id into v_pid from public.products where name = 'เก้าอี้แคมป์ปิ้งพับได้ โครงเหล็กแข็งแรงรับน้ำหนัก 120 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เก้าอี้แคมป์ปิ้งพับได้ โครงเหล็กแข็งแรงรับน้ำหนัก 120 กก.', 'เก้าอี้สนามผ้า Oxford 600D มีช่องวางแก้ว พับเก็บใส่ถุงสะพายพกขึ้นรถสะดวก', v_cat_id, 490, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop', 32, 5, true, 'CampThai', 'FDE-0158', '8850000000158', 'ตัว', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 32, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เก้าอี้สนามผ้า Oxford 600D มีช่องวางแก้ว พับเก็บใส่ถุงสะพายพกขึ้นรถสะดวก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop'), brand = 'CampThai', sku = 'FDE-0158', barcode = '8850000000158', unit = 'ตัว', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Camping & Outdoor';
    select product_id into v_pid from public.products where name = 'เต็นท์กางอัตโนมัติ 3-4 คน กันน้ำฝน 2000 มม.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เต็นท์กางอัตโนมัติ 3-4 คน กันน้ำฝน 2000 มม.', 'เต็นท์สปริงกางเสร็จใน 1 นาที มี 2 ประตู 2 หน้าต่างมุ้งกันยุง ระบายอากาศดี', v_cat_id, 1490, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop', 14, 5, true, 'CampThai', 'FDE-0159', '8850000000159', 'หลัง', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 14, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เต็นท์สปริงกางเสร็จใน 1 นาที มี 2 ประตู 2 หน้าต่างมุ้งกันยุง ระบายอากาศดี', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop'), brand = 'CampThai', sku = 'FDE-0159', barcode = '8850000000159', unit = 'หลัง', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Camping & Outdoor';
    select product_id into v_pid from public.products where name = 'ตะเกียงแคมป์ปิ้ง LED ชาร์จไฟได้ ปรับแสงวอร์มเป็นพาวเวอร์แบงค์ได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ตะเกียงแคมป์ปิ้ง LED ชาร์จไฟได้ ปรับแสงวอร์มเป็นพาวเวอร์แบงค์ได้', 'โคมไฟแคมป์ปิ้งสไตล์วินเทจ แบต 4000 mAh สว่างต่อเนื่อง 12 ชั่วโมง กันละอองน้ำ', v_cat_id, 390, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop', 38, 5, true, 'CampThai', 'FDE-0160', '8850000000160', 'อัน', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 38, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โคมไฟแคมป์ปิ้งสไตล์วินเทจ แบต 4000 mAh สว่างต่อเนื่อง 12 ชั่วโมง กันละอองน้ำ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop'), brand = 'CampThai', sku = 'FDE-0160', barcode = '8850000000160', unit = 'อัน', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Camping & Outdoor';
    select product_id into v_pid from public.products where name = 'ถังแช่น้ำแข็งเก็บความเย็นแคมป์ปิ้ง 25 ลิตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ถังแช่น้ำแข็งเก็บความเย็นแคมป์ปิ้ง 25 ลิตร', 'กระติกน้ำแข็งฉนวน PU หนา เก็บความเย็นได้นาน 48 ชั่วโมง เหมาะออกทริป', v_cat_id, 1290, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop', 15, 5, true, 'CampThai', 'FDE-0161', '8850000000161', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 15, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระติกน้ำแข็งฉนวน PU หนา เก็บความเย็นได้นาน 48 ชั่วโมง เหมาะออกทริป', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600&q=70&auto=format&fit=crop'), brand = 'CampThai', sku = 'FDE-0161', barcode = '8850000000161', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Milk & Food';
    select product_id into v_pid from public.products where name = 'นมผง Hi-Q 1 Plus ซูเปอร์โกลด์ สูตร 3 รสจืด 600 กรัม แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นมผง Hi-Q 1 Plus ซูเปอร์โกลด์ สูตร 3 รสจืด 600 กรัม แพ็ก 2', 'นมผงสำหรับเด็กอายุ 1 ปีขึ้นไป มีซินไบโอติก ดีเอชเอ และวิตามินบี 12 สูง', v_cat_id, 758, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Hi-Q (ไฮคิว)', 'FDE-0162', '8850000000162', 'แพ็ก 2 กล่อง', 2, array['halal', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นมผงสำหรับเด็กอายุ 1 ปีขึ้นไป มีซินไบโอติก ดีเอชเอ และวิตามินบี 12 สูง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop'), brand = 'Hi-Q (ไฮคิว)', sku = 'FDE-0162', barcode = '8850000000162', unit = 'แพ็ก 2 กล่อง', pack_qty = 2, tags = array['halal', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Milk & Food';
    select product_id into v_pid from public.products where name = 'นมยูเอชที Hi-Q 1 Plus รสจืด 180 มล. ลัง 36 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นมยูเอชที Hi-Q 1 Plus รสจืด 180 มล. ลัง 36 กล่อง', 'นมกล่องพร้อมดื่มสำหรับเด็ก รสจืดไม่เติมน้ำตาล ยกลัง 36 กล่องราคาประหยัด', v_cat_id, 549, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Hi-Q (ไฮคิว)', 'FDE-0163', '8850000000163', 'ลัง 36', 36, array['halal', 'fda', 'wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นมกล่องพร้อมดื่มสำหรับเด็ก รสจืดไม่เติมน้ำตาล ยกลัง 36 กล่องราคาประหยัด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop'), brand = 'Hi-Q (ไฮคิว)', sku = 'FDE-0163', barcode = '8850000000163', unit = 'ลัง 36', pack_qty = 36, tags = array['halal', 'fda', 'wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Milk & Food';
    select product_id into v_pid from public.products where name = 'อาหารเสริมธัญพืชเด็ก Cerelac สูตรข้าวสาลีและนม 250 ก. แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารเสริมธัญพืชเด็ก Cerelac สูตรข้าวสาลีและนม 250 ก. แพ็ก 2', 'อาหารเสริมสำหรับทารก 6 เดือนขึ้นไป เสริมธาตุเหล็กและโพรไบโอติก ชงง่าย', v_cat_id, 198, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Nestle', 'FDE-0164', '8850000000164', 'แพ็ก 2', 2, array['halal', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารเสริมสำหรับทารก 6 เดือนขึ้นไป เสริมธาตุเหล็กและโพรไบโอติก ชงง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=600&q=70&auto=format&fit=crop'), brand = 'Nestle', sku = 'FDE-0164', barcode = '8850000000164', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Diapers & Wipes';
    select product_id into v_pid from public.products where name = 'กางเกงผ้าอ้อมเด็ก MamyPoko Super Premium Organic ไซส์ L 44 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กางเกงผ้าอ้อมเด็ก MamyPoko Super Premium Organic ไซส์ L 44 ชิ้น', 'ผ้าอ้อมเด็กผิวสัมผัสนุ่มออร์แกนิกคอตตอน ซึมซับยาวนาน 12 ชม. ไม่แพ้ไม่ระคายเคือง', v_cat_id, 495, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'MamyPoko', 'FDE-0165', '8850000000165', 'ห่อ 44 ชิ้น', 44, array['organic', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าอ้อมเด็กผิวสัมผัสนุ่มออร์แกนิกคอตตอน ซึมซับยาวนาน 12 ชม. ไม่แพ้ไม่ระคายเคือง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop'), brand = 'MamyPoko', sku = 'FDE-0165', barcode = '8850000000165', unit = 'ห่อ 44 ชิ้น', pack_qty = 44, tags = array['organic', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Diapers & Wipes';
    select product_id into v_pid from public.products where name = 'ทิชชู่เปียกเด็กสูตรน้ำบริสุทธิ์ 99% แพ็ก 6 ห่อ (480 แผ่น)' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ทิชชู่เปียกเด็กสูตรน้ำบริสุทธิ์ 99% แพ็ก 6 ห่อ (480 แผ่น)', 'ผ้าเปียกปราศจากแอลกอฮอล์ พาราเบน และน้ำหอม ปลอดภัยต่อผิวบอบบางของทารก', v_cat_id, 249, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'Pureen', 'FDE-0166', '8850000000166', 'แพ็ก 6 ห่อ', 6, array['organic', 'wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าเปียกปราศจากแอลกอฮอล์ พาราเบน และน้ำหอม ปลอดภัยต่อผิวบอบบางของทารก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop'), brand = 'Pureen', sku = 'FDE-0166', barcode = '8850000000166', unit = 'แพ็ก 6 ห่อ', pack_qty = 6, tags = array['organic', 'wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Diapers & Wipes';
    select product_id into v_pid from public.products where name = 'น้ำยาซักผ้าเด็ก D-nee ออร์แกนิก 600 มล. แพ็ก 3 ถุง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาซักผ้าเด็ก D-nee ออร์แกนิก 600 มล. แพ็ก 3 ถุง', 'น้ำยาซักผ้าเด็กสูตรอ่อนโยน pH Balance ล้างออกง่าย กลิ่นหอมละมุน', v_cat_id, 195, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'D-nee', 'FDE-0167', '8850000000167', 'แพ็ก 3', 3, array['organic', 'eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำยาซักผ้าเด็กสูตรอ่อนโยน pH Balance ล้างออกง่าย กลิ่นหอมละมุน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?w=600&q=70&auto=format&fit=crop'), brand = 'D-nee', sku = 'FDE-0167', barcode = '8850000000167', unit = 'แพ็ก 3', pack_qty = 3, tags = array['organic', 'eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Gear';
    select product_id into v_pid from public.products where name = 'ขวดนมคอกว้าง PPSU ป้องกันโคลิค 8 ออนซ์ แพ็ก 2 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ขวดนมคอกว้าง PPSU ป้องกันโคลิค 8 ออนซ์ แพ็ก 2 ขวด', 'ขวดนมวัสดุ PPSU ทนความร้อน 180 องศา BPA-Free จุกนมเสมือนนมแม่', v_cat_id, 590, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Pigeon', 'FDE-0168', '8850000000168', 'แพ็ก 2', 2, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขวดนมวัสดุ PPSU ทนความร้อน 180 องศา BPA-Free จุกนมเสมือนนมแม่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop'), brand = 'Pigeon', sku = 'FDE-0168', barcode = '8850000000168', unit = 'แพ็ก 2', pack_qty = 2, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Gear';
    select product_id into v_pid from public.products where name = 'เครื่องนึ่งขวดนมไฟฟ้าพร้อมอบแห้งอัตโนมัติ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องนึ่งขวดนมไฟฟ้าพร้อมอบแห้งอัตโนมัติ', 'นึ่งฆ่าเชื้อแบคทีเรีย 99.9% และอบแห้งสนิทในขั้นตอนเดียว ใส่ได้ 8 ขวด', v_cat_id, 1890, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Camera', 'FDE-0169', '8850000000169', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นึ่งฆ่าเชื้อแบคทีเรีย 99.9% และอบแห้งสนิทในขั้นตอนเดียว ใส่ได้ 8 ขวด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop'), brand = 'Camera', sku = 'FDE-0169', barcode = '8850000000169', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'อาหารแมวโต Royal Canin Indoor 2 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารแมวโต Royal Canin Indoor 2 กก.', 'อาหารเม็ดสำหรับแมวเลี้ยงในบ้าน ลดกลิ่นมูล ควบคุมพลังงาน และช่วยลดก้อนขน', v_cat_id, 790, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Royal Canin', 'FDE-0170', '8850000000170', 'ถุง 2 กก.', 1, array['bestseller', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารเม็ดสำหรับแมวเลี้ยงในบ้าน ลดกลิ่นมูล ควบคุมพลังงาน และช่วยลดก้อนขน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Royal Canin', sku = 'FDE-0170', barcode = '8850000000170', unit = 'ถุง 2 กก.', pack_qty = 1, tags = array['bestseller', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'อาหารแมวโต Me-O รสปลาทู 3 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารแมวโต Me-O รสปลาทู 3 กก.', 'อาหารแมวสูตรครบถ้วน บำรุงสายตาด้วยทอรีน โซเดียมต่ำช่วยลดความเสี่ยงโรคนิ่ว', v_cat_id, 279, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Me-O', 'FDE-0171', '8850000000171', 'ถุง 3 กก.', 1, array['bestseller', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารแมวสูตรครบถ้วน บำรุงสายตาด้วยทอรีน โซเดียมต่ำช่วยลดความเสี่ยงโรคนิ่ว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Me-O', sku = 'FDE-0171', barcode = '8850000000171', unit = 'ถุง 3 กก.', pack_qty = 1, tags = array['bestseller', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'ขนมแมวเลีย Ciao Churu รสทูน่ารวม แพ็ก 20 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ขนมแมวเลีย Ciao Churu รสทูน่ารวม แพ็ก 20 ซอง', 'ขนมแมวเลียยอดฮิตจากญี่ปุ่น ไม่มีสารกันบูด เพิ่มความชุ่มชื้นและสานสัมพันธ์กับน้องแมว', v_cat_id, 265, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'Ciao', 'FDE-0172', '8850000000172', 'แพ็ก 20 ซอง', 20, array['no_msg', 'bestseller', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขนมแมวเลียยอดฮิตจากญี่ปุ่น ไม่มีสารกันบูด เพิ่มความชุ่มชื้นและสานสัมพันธ์กับน้องแมว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Ciao', sku = 'FDE-0172', barcode = '8850000000172', unit = 'แพ็ก 20 ซอง', pack_qty = 20, tags = array['no_msg', 'bestseller', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'อาหารเปียกแมว Nekko ปลาทูน่าในเยลลี่ แพ็ก 12 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารเปียกแมว Nekko ปลาทูน่าในเยลลี่ แพ็ก 12 ซอง', 'เนื้อปลาทูน่าแท้ 100% ไม่ผสมเนื้อเทียม เสริมวิตามินอีและพรีไบโอติก', v_cat_id, 216, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'Nekko', 'FDE-0173', '8850000000173', 'แพ็ก 12 ซอง', 12, array['no_msg', 'wholesale', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เนื้อปลาทูน่าแท้ 100% ไม่ผสมเนื้อเทียม เสริมวิตามินอีและพรีไบโอติก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Nekko', sku = 'FDE-0173', barcode = '8850000000173', unit = 'แพ็ก 12 ซอง', pack_qty = 12, tags = array['no_msg', 'wholesale', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'ทรายแมวเต้าหู้ธรรมชาติไร้ฝุ่น กลิ่นชาเขียว 6 ลิตร แพ็ก 3 ถุง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ทรายแมวเต้าหู้ธรรมชาติไร้ฝุ่น กลิ่นชาเขียว 6 ลิตร แพ็ก 3 ถุง', 'ทรายแมวเต้าหู้จับตัวเป็นก้อนไว ทิ้งลงชักโครกได้ ดับกลิ่นดี ไร้ฝุ่นปลอดภัยต่อระบบหายใจ', v_cat_id, 399, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Kasty', 'FDE-0174', '8850000000174', 'แพ็ก 3 ถุง', 3, array['eco', 'bestseller', 'pet_safe', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ทรายแมวเต้าหู้จับตัวเป็นก้อนไว ทิ้งลงชักโครกได้ ดับกลิ่นดี ไร้ฝุ่นปลอดภัยต่อระบบหายใจ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Kasty', sku = 'FDE-0174', barcode = '8850000000174', unit = 'แพ็ก 3 ถุง', pack_qty = 3, tags = array['eco', 'bestseller', 'pet_safe', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Dog Food & Treats';
    select product_id into v_pid from public.products where name = 'อาหารสุนัขโตพันธุ์เล็ก SmartHeart รสไก่และตับ 3 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารสุนัขโตพันธุ์เล็ก SmartHeart รสไก่และตับ 3 กก.', 'อาหารสุนัขสูตรบำรุงขนเงางาม เสริมโอเมก้า 3&6 เม็ดเล็กเคี้ยวง่าย', v_cat_id, 249, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'SmartHeart', 'FDE-0175', '8850000000175', 'ถุง 3 กก.', 1, array['bestseller', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารสุนัขสูตรบำรุงขนเงางาม เสริมโอเมก้า 3&6 เม็ดเล็กเคี้ยวง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop'), brand = 'SmartHeart', sku = 'FDE-0175', barcode = '8850000000175', unit = 'ถุง 3 กก.', pack_qty = 1, tags = array['bestseller', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Dog Food & Treats';
    select product_id into v_pid from public.products where name = 'อาหารสุนัขโต Royal Canin Mini Adult 2 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารสุนัขโต Royal Canin Mini Adult 2 กก.', 'อาหารสุนัขพันธุ์เล็กเกรดพรีเมียม ย่อยง่าย ดูแลสุขภาพผิวหนังและลดคราบหินปูน', v_cat_id, 745, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Royal Canin', 'FDE-0176', '8850000000176', 'ถุง 2 กก.', 1, array['pet_safe', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารสุนัขพันธุ์เล็กเกรดพรีเมียม ย่อยง่าย ดูแลสุขภาพผิวหนังและลดคราบหินปูน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop'), brand = 'Royal Canin', sku = 'FDE-0176', barcode = '8850000000176', unit = 'ถุง 2 กก.', pack_qty = 1, tags = array['pet_safe', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Dog Food & Treats';
    select product_id into v_pid from public.products where name = 'ขนมขัดฟันสุนัข Pedigree Dentastix แพ็ก 4 ห่อ (28 แท่ง)' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ขนมขัดฟันสุนัข Pedigree Dentastix แพ็ก 4 ห่อ (28 แท่ง)', 'ขนมขัดฟันรูปตัว X ลดการสะสมคราบหินปูนได้ถึง 80% ลมหายใจสดชื่น', v_cat_id, 295, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Pedigree', 'FDE-0177', '8850000000177', 'แพ็ก 4 ห่อ', 4, array['pet_safe', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขนมขัดฟันรูปตัว X ลดการสะสมคราบหินปูนได้ถึง 80% ลมหายใจสดชื่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop'), brand = 'Pedigree', sku = 'FDE-0177', barcode = '8850000000177', unit = 'แพ็ก 4 ห่อ', pack_qty = 4, tags = array['pet_safe', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Dog Food & Treats';
    select product_id into v_pid from public.products where name = 'สันในไก่อบแห้ง 100% ขนมสุนัขเกรดคนทาน 400 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สันในไก่อบแห้ง 100% ขนมสุนัขเกรดคนทาน 400 กรัม', 'สันในไก่แท้ไม่ปรุงรส ไม่ใส่เกลือ ไม่ใส่สารกันบูด โปรตีนสูงไขมันต่ำ', v_cat_id, 259, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'JerHigh', 'FDE-0178', '8850000000178', 'ถุง', 1, array['no_msg', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สันในไก่แท้ไม่ปรุงรส ไม่ใส่เกลือ ไม่ใส่สารกันบูด โปรตีนสูงไขมันต่ำ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop'), brand = 'JerHigh', sku = 'FDE-0178', barcode = '8850000000178', unit = 'ถุง', pack_qty = 1, tags = array['no_msg', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'น้ำพุแมวและสุนัขอัตโนมัติไร้เสียง 2 ลิตร พร้อมไส้กรอง 3 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำพุแมวและสุนัขอัตโนมัติไร้เสียง 2 ลิตร พร้อมไส้กรอง 3 ชิ้น', 'น้ำพุกรองน้ำ 4 ชั้น กระตุ้นให้น้องแมวดื่มน้ำมากขึ้น ลดโรคไต ปั๊มเงียบประหยัดไฟ', v_cat_id, 690, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 26, 5, true, 'Petkit', 'FDE-0179', '8850000000179', 'ชุด', 1, array['warranty_1y', 'bestseller', 'pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 26, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำพุกรองน้ำ 4 ชั้น กระตุ้นให้น้องแมวดื่มน้ำมากขึ้น ลดโรคไต ปั๊มเงียบประหยัดไฟ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Petkit', sku = 'FDE-0179', barcode = '8850000000179', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y', 'bestseller', 'pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'ชามอาหารสัตว์เลี้ยงสแตนเลสคู่ยกสูงป้องกันกรดไหลย้อน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชามอาหารสัตว์เลี้ยงสแตนเลสคู่ยกสูงป้องกันกรดไหลย้อน', 'ชามคู่ปรับเอียง 15 องศา ถนอมกระดูกคอ ล้างทำความสะอาดง่ายไม่เป็นสนิม', v_cat_id, 249, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Paw & Glow', 'FDE-0180', '8850000000180', 'ชุด', 1, array['pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชามคู่ปรับเอียง 15 องศา ถนอมกระดูกคอ ล้างทำความสะอาดง่ายไม่เป็นสนิม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0180', barcode = '8850000000180', unit = 'ชุด', pack_qty = 1, tags = array['pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'แชมพูอาบน้ำสุนัขและแมวสูตรออร์แกนิกข้าวโอ๊ต 500 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แชมพูอาบน้ำสุนัขและแมวสูตรออร์แกนิกข้าวโอ๊ต 500 มล.', 'แชมพูสูตรอ่อนโยนลดอาการคันและขนร่วง หอมละมุน ล้างออกง่าย ปลอดภัยหากน้องเลียขน', v_cat_id, 289, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Paw & Glow', 'FDE-0181', '8850000000181', 'ขวด', 1, array['organic', 'pet_safe', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แชมพูสูตรอ่อนโยนลดอาการคันและขนร่วง หอมละมุน ล้างออกง่าย ปลอดภัยหากน้องเลียขน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0181', barcode = '8850000000181', unit = 'ขวด', pack_qty = 1, tags = array['organic', 'pet_safe', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'แผ่นรองฉี่สุนัขคาร์บอนดับกลิ่น ไซส์ M 50 แผ่น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แผ่นรองฉี่สุนัขคาร์บอนดับกลิ่น ไซส์ M 50 แผ่น', 'แผ่นรองซับ 6 ชั้นผสมผงถ่านชาร์โคล ดูดซับเร็วไม่ไหลย้อนกลับ ดับกลิ่นฉี่ได้ดีเยี่ยม', v_cat_id, 229, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'Paw & Glow', 'FDE-0182', '8850000000182', 'ห่อ 50 แผ่น', 50, array['pet_safe', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แผ่นรองซับ 6 ชั้นผสมผงถ่านชาร์โคล ดูดซับเร็วไม่ไหลย้อนกลับ ดับกลิ่นฉี่ได้ดีเยี่ยม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0182', barcode = '8850000000182', unit = 'ห่อ 50 แผ่น', pack_qty = 50, tags = array['pet_safe', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'ครีมกันแดดทาหน้า Anessa Perfect UV Milk SPF50+ PA++++ 60 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ครีมกันแดดทาหน้า Anessa Perfect UV Milk SPF50+ PA++++ 60 มล.', 'กันแดดเนื้อน้ำนมบางเบา กันน้ำกันเหงื่อขั้นสุด ไม่เป็นคราบ คุมมันตลอดวัน', v_cat_id, 790, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Anessa', 'FDE-0183', '8850000000183', 'ขวด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กันแดดเนื้อน้ำนมบางเบา กันน้ำกันเหงื่อขั้นสุด ไม่เป็นคราบ คุมมันตลอดวัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'Anessa', sku = 'FDE-0183', barcode = '8850000000183', unit = 'ขวด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'ครีมกันแดดเนื้อเจลเบา Mizumi UV Water Serum SPF50+ 40 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ครีมกันแดดเนื้อเจลเบา Mizumi UV Water Serum SPF50+ 40 กรัม', 'กันแดดสูตรน้ำ 100% ปราศจากน้ำมัน น้ำหอม และพาราเบน เหมาะกับผิวแพ้ง่ายเป็นสิว', v_cat_id, 449, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'MizuMi', 'FDE-0184', '8850000000184', 'หลอด', 1, array['fda', 'bestseller', 'eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กันแดดสูตรน้ำ 100% ปราศจากน้ำมัน น้ำหอม และพาราเบน เหมาะกับผิวแพ้ง่ายเป็นสิว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'MizuMi', sku = 'FDE-0184', barcode = '8850000000184', unit = 'หลอด', pack_qty = 1, tags = array['fda', 'bestseller', 'eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'คลีนซิ่งวอเตอร์เช็ดเครื่องสำอาง Bioderma Sensibio H2O 500 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คลีนซิ่งวอเตอร์เช็ดเครื่องสำอาง Bioderma Sensibio H2O 500 มล.', 'ไมเซล่าเช็ดหน้าสูตรสีชมพูสำหรับผิวบอบบาง แพ้ง่าย ทำความสะอาดล้ำลึกไม่แห้งตึง', v_cat_id, 690, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 38, 5, true, 'Bioderma', 'FDE-0185', '8850000000185', 'ขวด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 38, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไมเซล่าเช็ดหน้าสูตรสีชมพูสำหรับผิวบอบบาง แพ้ง่าย ทำความสะอาดล้ำลึกไม่แห้งตึง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'Bioderma', sku = 'FDE-0185', barcode = '8850000000185', unit = 'ขวด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'เซรั่มไฮยาลูรอนเติมความชุ่มชื้น La Roche-Posay Hyalu B5 30 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เซรั่มไฮยาลูรอนเติมความชุ่มชื้น La Roche-Posay Hyalu B5 30 มล.', 'เซรั่มวิตามินบี 5 และไฮยาลูรอน ฟื้นบำรุงผิวอิ่มฟู ลดริ้วรอยแรกเริ่ม', v_cat_id, 1190, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'La Roche-Posay', 'FDE-0186', '8850000000186', 'ขวด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เซรั่มวิตามินบี 5 และไฮยาลูรอน ฟื้นบำรุงผิวอิ่มฟู ลดริ้วรอยแรกเริ่ม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'La Roche-Posay', sku = 'FDE-0186', barcode = '8850000000186', unit = 'ขวด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'เจลล้างหน้าอ่อนโยน Cerave Foaming Cleanser 236 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เจลล้างหน้าอ่อนโยน Cerave Foaming Cleanser 236 มล.', 'ผลิตภัณฑ์ทำความสะอาดผิวหน้าสำหรับผิวธรรมดา-ผิวมัน เสริมเซราไมด์ 3 ชนิด', v_cat_id, 445, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'CeraVe', 'FDE-0187', '8850000000187', 'ขวด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผลิตภัณฑ์ทำความสะอาดผิวหน้าสำหรับผิวธรรมดา-ผิวมัน เสริมเซราไมด์ 3 ชนิด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'CeraVe', sku = 'FDE-0187', barcode = '8850000000187', unit = 'ขวด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'มอยส์เจอไรเซอร์โลชั่น Cerave Daily Moisturizing 473 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'มอยส์เจอไรเซอร์โลชั่น Cerave Daily Moisturizing 473 มล.', 'โลชั่นบำรุงผิวหน้าและผิวกาย เนื้อบางเบาไม่เหนียวเหนอะหนะ ชุ่มชื้น 24 ชั่วโมง', v_cat_id, 649, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 42, 5, true, 'CeraVe', 'FDE-0188', '8850000000188', 'ขวด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 42, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โลชั่นบำรุงผิวหน้าและผิวกาย เนื้อบางเบาไม่เหนียวเหนอะหนะ ชุ่มชื้น 24 ชั่วโมง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'CeraVe', sku = 'FDE-0188', barcode = '8850000000188', unit = 'ขวด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'แผ่นมาสก์หน้าวิตามินซีบำรุงผิวกระจ่างใส แพ็ก 10 แผ่น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แผ่นมาสก์หน้าวิตามินซีบำรุงผิวกระจ่างใส แพ็ก 10 แผ่น', 'มาสก์หน้าเจลลี่จากเกาหลี อุดมวิตามินเข้มข้น ผิวฉ่ำน้ำทันทีหลังใช้', v_cat_id, 290, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Banobagi', 'FDE-0189', '8850000000189', 'แพ็ก 10 แผ่น', 10, array['fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'มาสก์หน้าเจลลี่จากเกาหลี อุดมวิตามินเข้มข้น ผิวฉ่ำน้ำทันทีหลังใช้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'Banobagi', sku = 'FDE-0189', barcode = '8850000000189', unit = 'แพ็ก 10 แผ่น', pack_qty = 10, tags = array['fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hair & Body Care';
    select product_id into v_pid from public.products where name = 'แชมพูสูตรลดผมขาดหลุดร่วงสมุนไพรอัญชันออร์แกนิก 400 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แชมพูสูตรลดผมขาดหลุดร่วงสมุนไพรอัญชันออร์แกนิก 400 มล.', 'แชมพูธรรมชาติปราศจากซิลิโคนและ SLS บำรุงรากผมแข็งแรงเงางาม', v_cat_id, 179, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Khaokho Talaypu', 'FDE-0190', '8850000000190', 'ขวด', 1, array['organic', 'eco', 'fda', 'vegan']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แชมพูธรรมชาติปราศจากซิลิโคนและ SLS บำรุงรากผมแข็งแรงเงางาม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop'), brand = 'Khaokho Talaypu', sku = 'FDE-0190', barcode = '8850000000190', unit = 'ขวด', pack_qty = 1, tags = array['organic', 'eco', 'fda', 'vegan']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hair & Body Care';
    select product_id into v_pid from public.products where name = 'ครีมอาบน้ำบำรุงผิว Shokubutsu 500 มล. แพ็ก 2 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ครีมอาบน้ำบำรุงผิว Shokubutsu 500 มล. แพ็ก 2 ขวด', 'ครีมอาบน้ำสารสกัดจากพืชธรรมชาติ 99% ฟองนุ่มละเอียด ผิวนุ่มชุ่มชื้น', v_cat_id, 219, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'Shokubutsu', 'FDE-0191', '8850000000191', 'แพ็ก 2', 2, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ครีมอาบน้ำสารสกัดจากพืชธรรมชาติ 99% ฟองนุ่มละเอียด ผิวนุ่มชุ่มชื้น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop'), brand = 'Shokubutsu', sku = 'FDE-0191', barcode = '8850000000191', unit = 'แพ็ก 2', pack_qty = 2, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hair & Body Care';
    select product_id into v_pid from public.products where name = 'ยาสีฟันสมุนไพรเทพไทย สูตรดั้งเดิม 70 กรัม แพ็ก 3 หลอด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ยาสีฟันสมุนไพรเทพไทย สูตรดั้งเดิม 70 กรัม แพ็ก 3 หลอด', 'ยาสีฟันสมุนไพรเข้มข้น ใช้เท่าเมล็ดถั่วเขียว ลดกลิ่นปากและคราบหินปูนได้ดี', v_cat_id, 255, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'เทพไทย', 'FDE-0192', '8850000000192', 'แพ็ก 3', 3, array['halal', 'fda', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ยาสีฟันสมุนไพรเข้มข้น ใช้เท่าเมล็ดถั่วเขียว ลดกลิ่นปากและคราบหินปูนได้ดี', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=600&q=70&auto=format&fit=crop'), brand = 'เทพไทย', sku = 'FDE-0192', barcode = '8850000000192', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'fda', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fragrance & Aroma';
    select product_id into v_pid from public.products where name = 'ก้านไม้หอมปรับอากาศ กลิ่นชาขาวและมะลิ 120 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ก้านไม้หอมปรับอากาศ กลิ่นชาขาวและมะลิ 120 มล.', 'Reed Diffuser น้ำมันหอมระเหยแท้ กระจายกลิ่นหอมละมุนในห้องนั่งเล่นและห้องนอน 60 วัน', v_cat_id, 290, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Paw & Glow', 'FDE-0193', '8850000000193', 'ขวด', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'Reed Diffuser น้ำมันหอมระเหยแท้ กระจายกลิ่นหอมละมุนในห้องนั่งเล่นและห้องนอน 60 วัน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0193', barcode = '8850000000193', unit = 'ขวด', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Vitamins & Supplements';
    select product_id into v_pid from public.products where name = 'วิตามินซี 1000 มก. Blackmores Bio C 62 เม็ด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'วิตามินซี 1000 มก. Blackmores Bio C 62 เม็ด', 'วิตามินซีสูตรเสริมไบโอฟลาโวนอยด์ ช่วยเสริมภูมิคุ้มกันและต้านอนุมูลอิสระ', v_cat_id, 495, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Blackmores', 'FDE-0194', '8850000000194', 'ขวด 62 เม็ด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'วิตามินซีสูตรเสริมไบโอฟลาโวนอยด์ ช่วยเสริมภูมิคุ้มกันและต้านอนุมูลอิสระ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop'), brand = 'Blackmores', sku = 'FDE-0194', barcode = '8850000000194', unit = 'ขวด 62 เม็ด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Vitamins & Supplements';
    select product_id into v_pid from public.products where name = 'น้ำมันปลาโอเมก้า 3 Blackmores Fish Oil 1000 มก. 80 แคปซูล' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมันปลาโอเมก้า 3 Blackmores Fish Oil 1000 มก. 80 แคปซูล', 'น้ำมันปลาไร้กลิ่นคาว บำรุงสมอง สายตา และหัวใจ ผ่านการตรวจสารปรอท', v_cat_id, 459, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Blackmores', 'FDE-0195', '8850000000195', 'ขวด 80 เม็ด', 1, array['fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมันปลาไร้กลิ่นคาว บำรุงสมอง สายตา และหัวใจ ผ่านการตรวจสารปรอท', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop'), brand = 'Blackmores', sku = 'FDE-0195', barcode = '8850000000195', unit = 'ขวด 80 เม็ด', pack_qty = 1, tags = array['fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Vitamins & Supplements';
    select product_id into v_pid from public.products where name = 'เวย์โปรตีนไอโซเลท รสช็อกโกแลต ไขมันต่ำ 1 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เวย์โปรตีนไอโซเลท รสช็อกโกแลต ไขมันต่ำ 1 กก.', 'โปรตีนสูง 27 กรัมต่อช้อน น้ำตาลน้อย ละลายง่าย เสริมสร้างกล้ามเนื้อหลังออกกำลังกาย', v_cat_id, 990, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'FitWhey', 'FDE-0196', '8850000000196', 'ถุง 1 กก.', 1, array['halal', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โปรตีนสูง 27 กรัมต่อช้อน น้ำตาลน้อย ละลายง่าย เสริมสร้างกล้ามเนื้อหลังออกกำลังกาย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop'), brand = 'FitWhey', sku = 'FDE-0196', barcode = '8850000000196', unit = 'ถุง 1 กก.', pack_qty = 1, tags = array['halal', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'First Aid & Care';
    select product_id into v_pid from public.products where name = 'หน้ากากอนามัยทางการแพทย์ 3 ชั้น 50 ชิ้น แพ็ก 2 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หน้ากากอนามัยทางการแพทย์ 3 ชั้น 50 ชิ้น แพ็ก 2 กล่อง', 'หน้ากากกรองเชื้อแบคทีเรียและฝุ่น PM2.5 BFE/PFE 99% สายคล้องหูนุ่มไม่เจ็บหู', v_cat_id, 179, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop', 100, 5, true, 'Iris Ohyama', 'FDE-0197', '8850000000197', 'แพ็ก 2 กล่อง', 2, array['fda', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 100, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หน้ากากกรองเชื้อแบคทีเรียและฝุ่น PM2.5 BFE/PFE 99% สายคล้องหูนุ่มไม่เจ็บหู', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop'), brand = 'Iris Ohyama', sku = 'FDE-0197', barcode = '8850000000197', unit = 'แพ็ก 2 กล่อง', pack_qty = 2, tags = array['fda', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'First Aid & Care';
    select product_id into v_pid from public.products where name = 'เจลแอลกอฮอล์ล้างมือ 75% Food Grade 500 มล. แพ็ก 2 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เจลแอลกอฮอล์ล้างมือ 75% Food Grade 500 มล. แพ็ก 2 ขวด', 'เจลล้างมือไม่เหนียวเหนอะหนะ ผสมอโลเวร่าถนอมมือ ฆ่าเชื้อโรค 99.9%', v_cat_id, 169, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'KireiKirei', 'FDE-0198', '8850000000198', 'แพ็ก 2', 2, array['fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เจลล้างมือไม่เหนียวเหนอะหนะ ผสมอโลเวร่าถนอมมือ ฆ่าเชื้อโรค 99.9%', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop'), brand = 'KireiKirei', sku = 'FDE-0198', barcode = '8850000000198', unit = 'แพ็ก 2', pack_qty = 2, tags = array['fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'First Aid & Care';
    select product_id into v_pid from public.products where name = 'ปรอทวัดไข้ดิจิทัลปลายอ่อนอ่านค่าใน 10 วินาที Omron' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปรอทวัดไข้ดิจิทัลปลายอ่อนอ่านค่าใน 10 วินาที Omron', 'เครื่องวัดอุณหภูมิมาตรฐานการแพทย์ แม่นยำ กันน้ำ มีเสียงเตือนเมื่อวัดเสร็จ', v_cat_id, 265, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Omron', 'FDE-0199', '8850000000199', 'อัน', 1, array['fda', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องวัดอุณหภูมิมาตรฐานการแพทย์ แม่นยำ กันน้ำ มีเสียงเตือนเมื่อวัดเสร็จ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop'), brand = 'Omron', sku = 'FDE-0199', barcode = '8850000000199', unit = 'อัน', pack_qty = 1, tags = array['fda', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'First Aid & Care';
    select product_id into v_pid from public.products where name = 'ชุดปฐมพยาบาลฉุกเฉินประจำบ้านและรถยนต์ 45 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดปฐมพยาบาลฉุกเฉินประจำบ้านและรถยนต์ 45 ชิ้น', 'พลาสเตอร์ยา ผ้าก๊อซ เทปแต่งแผล น้ำเกลือ กรรไกร ครบชุดในกล่องพกพากันน้ำ', v_cat_id, 390, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop', 35, 5, true, '3M', 'FDE-0200', '8850000000200', 'กล่อง', 1, array['fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'พลาสเตอร์ยา ผ้าก๊อซ เทปแต่งแผล น้ำเกลือ กรรไกร ครบชุดในกล่องพกพากันน้ำ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0200', barcode = '8850000000200', unit = 'กล่อง', pack_qty = 1, tags = array['fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pens & Notebooks';
    select product_id into v_pid from public.products where name = 'ปากกาเจลเขียนลื่น Pentel EnerGel 0.5 มม. น้ำเงิน แพ็ก 6 ด้าม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปากกาเจลเขียนลื่น Pentel EnerGel 0.5 มม. น้ำเงิน แพ็ก 6 ด้าม', 'ปากกาหมึกเจลแห้งไวไม่เลอะมือ เขียนลื่นสุดๆ ยอดนิยมสำหรับนักเรียนและออฟฟิศ', v_cat_id, 210, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'Pentel', 'FDE-0201', '8850000000201', 'แพ็ก 6 ด้าม', 6, array['bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปากกาหมึกเจลแห้งไวไม่เลอะมือ เขียนลื่นสุดๆ ยอดนิยมสำหรับนักเรียนและออฟฟิศ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop'), brand = 'Pentel', sku = 'FDE-0201', barcode = '8850000000201', unit = 'แพ็ก 6 ด้าม', pack_qty = 6, tags = array['bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pens & Notebooks';
    select product_id into v_pid from public.products where name = 'ชุดปากกาไฮไลท์สีพาสเทล Stabilo Boss 6 สี' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดปากกาไฮไลท์สีพาสเทล Stabilo Boss 6 สี', 'ปากกาเน้นข้อความสีพาสเทลถนอมสายตา เปิดฝาทิ้งไว้ได้ 4 ชม. หมึกไม่แห้ง', v_cat_id, 249, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'Stabilo', 'FDE-0202', '8850000000202', 'ชุด 6 ด้าม', 6, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ปากกาเน้นข้อความสีพาสเทลถนอมสายตา เปิดฝาทิ้งไว้ได้ 4 ชม. หมึกไม่แห้ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop'), brand = 'Stabilo', sku = 'FDE-0202', barcode = '8850000000202', unit = 'ชุด 6 ด้าม', pack_qty = 6, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pens & Notebooks';
    select product_id into v_pid from public.products where name = 'สมุดโน้ตปกแข็งสันห่วง A5 กระดาษถนอมสายตา 100 แกรม แพ็ก 2 เล่ม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สมุดโน้ตปกแข็งสันห่วง A5 กระดาษถนอมสายตา 100 แกรม แพ็ก 2 เล่ม', 'สมุดจดบันทึกมีเส้นบรรทัด กระดาษหนาเขียนไม่ซึมทะลุ เหมาะกับปากกาหมึกเจลและหมึกซึม', v_cat_id, 178, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'Muji Style', 'FDE-0203', '8850000000203', 'แพ็ก 2 เล่ม', 2, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สมุดจดบันทึกมีเส้นบรรทัด กระดาษหนาเขียนไม่ซึมทะลุ เหมาะกับปากกาหมึกเจลและหมึกซึม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop'), brand = 'Muji Style', sku = 'FDE-0203', barcode = '8850000000203', unit = 'แพ็ก 2 เล่ม', pack_qty = 2, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pens & Notebooks';
    select product_id into v_pid from public.products where name = 'กระดาษโพสต์อิท 3M Post-it สีพาสเทล 3x3 นิ้ว แพ็ก 6 ก้อน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระดาษโพสต์อิท 3M Post-it สีพาสเทล 3x3 นิ้ว แพ็ก 6 ก้อน', 'กระดาษโน้ตกาวในตัวติดแน่นลอกออกไม่ทิ้งคราบ แพ็กสุดคุ้ม 600 แผ่น', v_cat_id, 185, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop', 80, 5, true, '3M', 'FDE-0204', '8850000000204', 'แพ็ก 6 ก้อน', 6, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระดาษโน้ตกาวในตัวติดแน่นลอกออกไม่ทิ้งคราบ แพ็กสุดคุ้ม 600 แผ่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0204', barcode = '8850000000204', unit = 'แพ็ก 6 ก้อน', pack_qty = 6, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'ชั้นวางจอคอมพิวเตอร์ไม้ไผ่พร้อมลิ้นชักจัดระเบียบโต๊ะ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชั้นวางจอคอมพิวเตอร์ไม้ไผ่พร้อมลิ้นชักจัดระเบียบโต๊ะ', 'แท่นวางมอนิเตอร์ปรับระดับสายตา ลดปวดคอ ด้านล่างสอดเก็บคีย์บอร์ดได้ประหยัดพื้นที่', v_cat_id, 490, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 32, 5, true, 'Paw & Glow', 'FDE-0205', '8850000000205', 'ชิ้น', 1, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 32, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แท่นวางมอนิเตอร์ปรับระดับสายตา ลดปวดคอ ด้านล่างสอดเก็บคีย์บอร์ดได้ประหยัดพื้นที่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0205', barcode = '8850000000205', unit = 'ชิ้น', pack_qty = 1, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'กล่องจัดระเบียบสายไฟบนโต๊ะทำงาน ป้องกันฝุ่น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล่องจัดระเบียบสายไฟบนโต๊ะทำงาน ป้องกันฝุ่น', 'กล่องซ่อนรางปลั๊กไฟและอะแดปเตอร์ ทำให้โต๊ะทำงานเป็นระเบียบและปลอดภัยจากเด็ก/สัตว์เลี้ยง', v_cat_id, 249, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Paw & Glow', 'FDE-0206', '8850000000206', 'ใบ', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กล่องซ่อนรางปลั๊กไฟและอะแดปเตอร์ ทำให้โต๊ะทำงานเป็นระเบียบและปลอดภัยจากเด็ก/สัตว์เลี้ยง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0206', barcode = '8850000000206', unit = 'ใบ', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'แฟ้มใส่เอกสาร A4 สันรูดพลาสติกใส แพ็ก 12 เล่ม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แฟ้มใส่เอกสาร A4 สันรูดพลาสติกใส แพ็ก 12 เล่ม', 'แฟ้มหนีบเอกสารแข็งแรง สีพาสเทลคละสี จัดเก็บเอกสารเป็นหมวดหมู่', v_cat_id, 145, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'Elephant', 'FDE-0207', '8850000000207', 'แพ็ก 12 เล่ม', 12, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แฟ้มหนีบเอกสารแข็งแรง สีพาสเทลคละสี จัดเก็บเอกสารเป็นหมวดหมู่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Elephant', sku = 'FDE-0207', barcode = '8850000000207', unit = 'แพ็ก 12 เล่ม', pack_qty = 12, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Printer & Supplies';
    select product_id into v_pid from public.products where name = 'กระดาษถ่ายเอกสาร A4 Double A 80 แกรม แพ็ก 5 รีม (ยกลัง)' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระดาษถ่ายเอกสาร A4 Double A 80 แกรม แพ็ก 5 รีม (ยกลัง)', 'กระดาษ A4 เรียบลื่นไม่ติดเครื่อง พิมพ์สวยทั้ง 2 หน้า ยกลัง 5 รีม (2,500 แผ่น) ราคาส่ง', v_cat_id, 645, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Double A', 'FDE-0208', '8850000000208', 'ลัง 5 รีม', 5, array['eco', 'bestseller', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระดาษ A4 เรียบลื่นไม่ติดเครื่อง พิมพ์สวยทั้ง 2 หน้า ยกลัง 5 รีม (2,500 แผ่น) ราคาส่ง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop'), brand = 'Double A', sku = 'FDE-0208', barcode = '8850000000208', unit = 'ลัง 5 รีม', pack_qty = 5, tags = array['eco', 'bestseller', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Printer & Supplies';
    select product_id into v_pid from public.products where name = 'เทปใสปิดกล่องพัสดุ 2 นิ้ว 45 หลา แพ็ก 6 ม้วน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เทปใสปิดกล่องพัสดุ 2 นิ้ว 45 หลา แพ็ก 6 ม้วน', 'เทปโอพีพีเหนียวพิเศษ กาวอะคริลิคติดกล่องลังแน่นไม่หลุด สำหรับร้านค้าออนไลน์', v_cat_id, 139, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop', 100, 5, true, 'Louis', 'FDE-0209', '8850000000209', 'แพ็ก 6 ม้วน', 6, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 100, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เทปโอพีพีเหนียวพิเศษ กาวอะคริลิคติดกล่องลังแน่นไม่หลุด สำหรับร้านค้าออนไลน์', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop'), brand = 'Louis', sku = 'FDE-0209', barcode = '8850000000209', unit = 'แพ็ก 6 ม้วน', pack_qty = 6, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Printer & Supplies';
    select product_id into v_pid from public.products where name = 'เครื่องคิดเลขตั้งโต๊ะ 12 หลัก Casio MX-12B แท้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องคิดเลขตั้งโต๊ะ 12 หลัก Casio MX-12B แท้', 'เครื่องคิดเลขปุ่มใหญ่กดง่าย ใช้พลังงานแสงอาทิตย์และถ่าน จอใหญ่ชัด', v_cat_id, 295, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Casio', 'FDE-0210', '8850000000210', 'เครื่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องคิดเลขปุ่มใหญ่กดง่าย ใช้พลังงานแสงอาทิตย์และถ่าน จอใหญ่ชัด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop'), brand = 'Casio', sku = 'FDE-0210', barcode = '8850000000210', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Printer & Supplies';
    select product_id into v_pid from public.products where name = 'เครื่องเย็บกระดาษตั้งโต๊ะ Elephant เบอร์ 10 พร้อมลวดเย็บ 5 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องเย็บกระดาษตั้งโต๊ะ Elephant เบอร์ 10 พร้อมลวดเย็บ 5 กล่อง', 'แม็กซ์เย็บกระดาษเหล็กแข็งแรง เย็บได้ 20 แผ่นสบายมือ พร้อมลวดเย็บ 5,000 ตัว', v_cat_id, 159, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Elephant', 'FDE-0211', '8850000000211', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แม็กซ์เย็บกระดาษเหล็กแข็งแรง เย็บได้ 20 แผ่นสบายมือ พร้อมลวดเย็บ 5,000 ตัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop'), brand = 'Elephant', sku = 'FDE-0211', barcode = '8850000000211', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ซอสพริกศรีราชาพานิช 570 กรัม แพ็ก 2 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซอสพริกศรีราชาพานิช 570 กรัม แพ็ก 2 ขวด', 'ซอสพริกสูตรต้นตำรับ ไม่ใส่ผงชูรส ไม่เจือสี จิ้มไข่เจียวและหอยทอดอร่อยลงตัว', v_cat_id, 124, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 90, 5, true, 'ศรีราชาพานิช', 'FDE-0212', '8850000000212', 'แพ็ก 2', 2, array['halal', 'no_msg', 'vegan', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 90, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซอสพริกสูตรต้นตำรับ ไม่ใส่ผงชูรส ไม่เจือสี จิ้มไข่เจียวและหอยทอดอร่อยลงตัว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ศรีราชาพานิช', sku = 'FDE-0212', barcode = '8850000000212', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'no_msg', 'vegan', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ซอสมะเขือเทศ โรซ่า 600 กรัม แพ็ก 2 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ซอสมะเขือเทศ โรซ่า 600 กรัม แพ็ก 2 ขวด', 'ซอสมะเขือเทศแท้ไม่ใส่วัตถุกันเสียและผงชูรส ไลโคปีนสูง', v_cat_id, 118, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 85, 5, true, 'โรซ่า (Roza)', 'FDE-0213', '8850000000213', 'แพ็ก 2', 2, array['halal', 'no_msg', 'vegan', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 85, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซอสมะเขือเทศแท้ไม่ใส่วัตถุกันเสียและผงชูรส ไลโคปีนสูง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'โรซ่า (Roza)', sku = 'FDE-0213', barcode = '8850000000213', unit = 'แพ็ก 2', pack_qty = 2, tags = array['halal', 'no_msg', 'vegan', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'วุ้นเส้นต้นสน แท้จากถั่วเขียว 100% 80 ก. แพ็ก 6 ห่อ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'วุ้นเส้นต้นสน แท้จากถั่วเขียว 100% 80 ก. แพ็ก 6 ห่อ', 'วุ้นเส้นเหนียวนุ่มไม่อืดง่าย เหมาะทำยำวุ้นเส้นและอบหม้อดิน', v_cat_id, 148, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'ต้นสน', 'FDE-0214', '8850000000214', 'แพ็ก 6', 6, array['halal', 'vegan', 'no_msg', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'วุ้นเส้นเหนียวนุ่มไม่อืดง่าย เหมาะทำยำวุ้นเส้นและอบหม้อดิน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'ต้นสน', sku = 'FDE-0214', barcode = '8850000000214', unit = 'แพ็ก 6', pack_qty = 6, tags = array['halal', 'vegan', 'no_msg', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'ผงปรุงรสคลีนจากผักและเห็ดหอม ไม่มีผงชูรส 150 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ผงปรุงรสคลีนจากผักและเห็ดหอม ไม่มีผงชูรส 150 กรัม', 'ผงปรุงรสเพื่อสุขภาพ โซเดียมต่ำ ไม่มีผงชูรสและสารกันบูด เด็กและผู้สูงอายุทานได้', v_cat_id, 115, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'CareChoice', 'FDE-0215', '8850000000215', 'กระปุก', 1, array['halal', 'vegan', 'no_msg', 'organic', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผงปรุงรสเพื่อสุขภาพ โซเดียมต่ำ ไม่มีผงชูรสและสารกันบูด เด็กและผู้สูงอายุทานได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'CareChoice', sku = 'FDE-0215', barcode = '8850000000215', unit = 'กระปุก', pack_qty = 1, tags = array['halal', 'vegan', 'no_msg', 'organic', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'น้ำมันงาคั่วหอมญี่ปุ่น Kadoya 221 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมันงาคั่วหอมญี่ปุ่น Kadoya 221 มล.', 'น้ำมันงาแท้ 100% หอมกลมกล่อม เหยาะซุป ผัดผัก หรือหมักเนื้อ', v_cat_id, 185, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Kadoya', 'FDE-0216', '8850000000216', 'ขวด', 1, array['vegan', 'no_msg', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมันงาแท้ 100% หอมกลมกล่อม เหยาะซุป ผัดผัก หรือหมักเนื้อ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'Kadoya', sku = 'FDE-0216', barcode = '8850000000216', unit = 'ขวด', pack_qty = 1, tags = array['vegan', 'no_msg', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'ชาเขียวพร้อมดื่ม อิชิตัน สูตรไม่มีน้ำตาล 420 มล. ลัง 24 ขวด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชาเขียวพร้อมดื่ม อิชิตัน สูตรไม่มีน้ำตาล 420 มล. ลัง 24 ขวด', 'ชาเขียวชงสดจากยอดอ่อนใบชา ไม่มีน้ำตาล 0 แคลอรี่ ยกลังสุดคุ้ม', v_cat_id, 369, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 60, 5, true, 'อิชิตัน', 'FDE-0217', '8850000000217', 'ลัง 24', 24, array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 60, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชาเขียวชงสดจากยอดอ่อนใบชา ไม่มีน้ำตาล 0 แคลอรี่ ยกลังสุดคุ้ม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'อิชิตัน', sku = 'FDE-0217', barcode = '8850000000217', unit = 'ลัง 24', pack_qty = 24, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'น้ำเก๊กฮวยหล่อฮังก๊วยสูตรหวานน้อย 250 มล. แพ็ก 12 กล่อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำเก๊กฮวยหล่อฮังก๊วยสูตรหวานน้อย 250 มล. แพ็ก 12 กล่อง', 'น้ำสมุนไพรดับกระหาย หวานน้อย หอมดอกเก๊กฮวยแท้', v_cat_id, 192, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'ดอยคำ', 'FDE-0218', '8850000000218', 'แพ็ก 12', 12, array['halal', 'vegan', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำสมุนไพรดับกระหาย หวานน้อย หอมดอกเก๊กฮวยแท้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'ดอยคำ', sku = 'FDE-0218', barcode = '8850000000218', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'vegan', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'กาแฟสำเร็จรูป Nescafe Gold Crema 200 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กาแฟสำเร็จรูป Nescafe Gold Crema 200 กรัม', 'กาแฟผงละเอียดผสมอาราบิก้าคั่วบด ฟองเครม่านุ่มละมุน', v_cat_id, 339, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Nescafe', 'FDE-0219', '8850000000219', 'ขวด', 1, array['halal', 'low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กาแฟผงละเอียดผสมอาราบิก้าคั่วบด ฟองเครม่านุ่มละมุน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'Nescafe', sku = 'FDE-0219', barcode = '8850000000219', unit = 'ขวด', pack_qty = 1, tags = array['halal', 'low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'เมล็ดเจียออร์แกนิก Organic Chia Seeds 500 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เมล็ดเจียออร์แกนิก Organic Chia Seeds 500 กรัม', 'ซุปเปอร์ฟู้ดไฟเบอร์และโอเมก้า 3 สูง แช่น้ำหรือใส่สมูทตี้ได้', v_cat_id, 179, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Organic Siam', 'FDE-0220', '8850000000220', 'ถุง', 1, array['halal', 'vegan', 'organic', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซุปเปอร์ฟู้ดไฟเบอร์และโอเมก้า 3 สูง แช่น้ำหรือใส่สมูทตี้ได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Organic Siam', sku = 'FDE-0220', barcode = '8850000000220', unit = 'ถุง', pack_qty = 1, tags = array['halal', 'vegan', 'organic', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Snacks & Bakery';
    select product_id into v_pid from public.products where name = 'กล้วยหอมกรอบอบสูญญากาศไม่ทอด 120 กรัม แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กล้วยหอมกรอบอบสูญญากาศไม่ทอด 120 กรัม แพ็ก 3', 'ผลไม้อบกรอบไร้น้ำมัน ไม่เติมน้ำตาล กรอบหอมอร่อย', v_cat_id, 195, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Siam Crunch', 'FDE-0221', '8850000000221', 'แพ็ก 3', 3, array['halal', 'vegan', 'no_msg', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผลไม้อบกรอบไร้น้ำมัน ไม่เติมน้ำตาล กรอบหอมอร่อย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=70&auto=format&fit=crop'), brand = 'Siam Crunch', sku = 'FDE-0221', barcode = '8850000000221', unit = 'แพ็ก 3', pack_qty = 3, tags = array['halal', 'vegan', 'no_msg', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Beverages';
    select product_id into v_pid from public.products where name = 'น้ำมะพร้าวน้ำหอมแท้ 100% Malee Coco 330 มล. แพ็ก 12' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำมะพร้าวน้ำหอมแท้ 100% Malee Coco 330 มล. แพ็ก 12', 'น้ำมะพร้าวแท้ไม่เติมน้ำตาล สดชื่นเติมเกลือแร่ธรรมชาติหลังออกกำลังกาย', v_cat_id, 276, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'มาลี (Malee)', 'FDE-0222', '8850000000222', 'แพ็ก 12', 12, array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำมะพร้าวแท้ไม่เติมน้ำตาล สดชื่นเติมเกลือแร่ธรรมชาติหลังออกกำลังกาย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&q=70&auto=format&fit=crop'), brand = 'มาลี (Malee)', sku = 'FDE-0222', barcode = '8850000000222', unit = 'แพ็ก 12', pack_qty = 12, tags = array['halal', 'vegan', 'low_sugar', 'fda', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Pantry Siam Mart'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pantry & Condiments';
    select product_id into v_pid from public.products where name = 'เนยถั่วลิสงคลีน 100% ไม่เติมน้ำตาลและเกลือ 340 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เนยถั่วลิสงคลีน 100% ไม่เติมน้ำตาลและเกลือ 340 กรัม', 'เนยถั่วบดละเอียดหอมมันจากถั่วลิสงคั่ว 100% ไม่มีน้ำมันปาล์ม โปรตีนสูง', v_cat_id, 185, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Paweenee''s', 'FDE-0223', '8850000000223', 'กระปุก', 1, array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เนยถั่วบดละเอียดหอมมันจากถั่วลิสงคั่ว 100% ไม่มีน้ำมันปาล์ม โปรตีนสูง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=70&auto=format&fit=crop'), brand = 'Paweenee''s', sku = 'FDE-0223', barcode = '8850000000223', unit = 'กระปุก', pack_qty = 1, tags = array['halal', 'vegan', 'low_sugar', 'no_msg', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'หม้อทอดไร้น้ำมัน Philips 4.1 ลิตร Rapid Air' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หม้อทอดไร้น้ำมัน Philips 4.1 ลิตร Rapid Air', 'หม้อทอดไร้น้ำมันลดไขมันสูงสุด 90% ทอด อบ ย่าง ครบในเครื่องเดียว ล้างง่าย', v_cat_id, 2490, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 16, 5, true, 'Philips', 'FDE-0224', '8850000000224', 'เครื่อง', 1, array['tis', 'warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 16, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'หม้อทอดไร้น้ำมันลดไขมันสูงสุด 90% ทอด อบ ย่าง ครบในเครื่องเดียว ล้างง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Philips', sku = 'FDE-0224', barcode = '8850000000224', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'เครื่องปั่นสมูทตี้พลังสูง 600W โถแก้ว 1.5 ลิตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องปั่นสมูทตี้พลังสูง 600W โถแก้ว 1.5 ลิตร', 'เครื่องปั่นใบมีดสแตนเลส 6 แฉก ปั่นน้ำแข็งละเอียดเนียน โถแก้วหนาไม่ติดกลิ่น', v_cat_id, 1190, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 20, 5, true, 'Sharp', 'FDE-0225', '8850000000225', 'เครื่อง', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 20, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องปั่นใบมีดสแตนเลส 6 แฉก ปั่นน้ำแข็งละเอียดเนียน โถแก้วหนาไม่ติดกลิ่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Sharp', sku = 'FDE-0225', barcode = '8850000000225', unit = 'เครื่อง', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'เตาแม่เหล็กไฟฟ้าพร้อมหม้อสแตนเลส 2000W' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เตาแม่เหล็กไฟฟ้าพร้อมหม้อสแตนเลส 2000W', 'เตาไฟฟ้าหน้ากระจกคริสตัล ทำความสะอาดง่าย ปรับไฟ 6 ระดับ ตั้งเวลาได้', v_cat_id, 1450, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 18, 5, true, 'Philips', 'FDE-0226', '8850000000226', 'ชุด', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 18, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เตาไฟฟ้าหน้ากระจกคริสตัล ทำความสะอาดง่าย ปรับไฟ 6 ระดับ ตั้งเวลาได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Philips', sku = 'FDE-0226', barcode = '8850000000226', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Kitchen & Dining';
    select product_id into v_pid from public.products where name = 'ชั้นวางของในครัวสแตนเลส 4 ชั้น มีล้อเลื่อน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชั้นวางของในครัวสแตนเลส 4 ชั้น มีล้อเลื่อน', 'รถเข็นวางเครื่องปรุงและผักผลไม้ ประหยัดพื้นที่ซอกแคบ รับน้ำหนักได้ชั้นละ 15 กก.', v_cat_id, 590, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop', 28, 5, true, 'Somsri Craft', 'FDE-0227', '8850000000227', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 28, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'รถเข็นวางเครื่องปรุงและผักผลไม้ ประหยัดพื้นที่ซอกแคบ รับน้ำหนักได้ชั้นละ 15 กก.', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0227', barcode = '8850000000227', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'ราวตากผ้าสแตนเลสพับได้ทรง X ยืดหดได้ 2 เมตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ราวตากผ้าสแตนเลสพับได้ทรง X ยืดหดได้ 2 เมตร', 'ราวตากผ้านวมแข็งแรงไม่เป็นสนิม พับเก็บแนบผนังได้เมื่อไม่ใช้งาน', v_cat_id, 650, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 25, 5, true, 'Somsri Craft', 'FDE-0228', '8850000000228', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ราวตากผ้านวมแข็งแรงไม่เป็นสนิม พับเก็บแนบผนังได้เมื่อไม่ใช้งาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0228', barcode = '8850000000228', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cleaning & Laundry';
    select product_id into v_pid from public.products where name = 'น้ำยาทำความสะอาดห้องน้ำเป็ด โปร 900 มล. แพ็ก 3' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาทำความสะอาดห้องน้ำเป็ด โปร 900 มล. แพ็ก 3', 'ขจัดคราบฝังแน่นและคราบหินปูนในห้องน้ำ ฆ่าเชื้อแบคทีเรีย 99.9%', v_cat_id, 159, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'Duck', 'FDE-0229', '8850000000229', 'แพ็ก 3', 3, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ขจัดคราบฝังแน่นและคราบหินปูนในห้องน้ำ ฆ่าเชื้อแบคทีเรีย 99.9%', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&q=70&auto=format&fit=crop'), brand = 'Duck', sku = 'FDE-0229', barcode = '8850000000229', unit = 'แพ็ก 3', pack_qty = 3, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'ผ้าขนหนูเช็ดตัวคอตตอน 100% 30x60 นิ้ว ซับน้ำดี แพ็ก 2 ผืน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ผ้าขนหนูเช็ดตัวคอตตอน 100% 30x60 นิ้ว ซับน้ำดี แพ็ก 2 ผืน', 'ผ้าเช็ดตัวเกรดโรงแรม หนา 550 แกรม นุ่มฟูไม่เป็นขุย', v_cat_id, 399, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Somsri Craft', 'FDE-0230', '8850000000230', 'แพ็ก 2 ผืน', 2, array['eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ผ้าเช็ดตัวเกรดโรงแรม หนา 550 แกรม นุ่มฟูไม่เป็นขุย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Somsri Craft', sku = 'FDE-0230', barcode = '8850000000230', unit = 'แพ็ก 2 ผืน', pack_qty = 2, tags = array['eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Somsri Home & Living'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bedding & Decor';
    select product_id into v_pid from public.products where name = 'นาฬิกาแขวนผนังมินิมอลเดินเรียบไร้เสียง 12 นิ้ว' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'นาฬิกาแขวนผนังมินิมอลเดินเรียบไร้เสียง 12 นิ้ว', 'นาฬิกาแขวนเข็มเดินเรียบสนิทไม่มีเสียงติ๊กกวนใจเวลานอน ตัวเลขอ่านง่าย', v_cat_id, 590, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop', 22, 5, true, 'Seiko', 'FDE-0231', '8850000000231', 'เรือน', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 22, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'นาฬิกาแขวนเข็มเดินเรียบสนิทไม่มีเสียงติ๊กกวนใจเวลานอน ตัวเลขอ่านง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=70&auto=format&fit=crop'), brand = 'Seiko', sku = 'FDE-0231', barcode = '8850000000231', unit = 'เรือน', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'พัดลมตั้งโต๊ะไร้สายพับได้ แบต 4000 mAh ชาร์จ USB-C' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'พัดลมตั้งโต๊ะไร้สายพับได้ แบต 4000 mAh ชาร์จ USB-C', 'พัดลมพกพาเสียงเงียบ ปรับแรงลม 4 ระดับ ใช้งานไร้สายได้นาน 10 ชั่วโมง', v_cat_id, 459, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Xiaomi', 'FDE-0232', '8850000000232', 'เครื่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'พัดลมพกพาเสียงเงียบ ปรับแรงลม 4 ระดับ ใช้งานไร้สายได้นาน 10 ชั่วโมง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Xiaomi', sku = 'FDE-0232', barcode = '8850000000232', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'คีย์บอร์ดไร้สายบางเฉียบเชื่อมได้ 3 เครื่อง Logitech K380s' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คีย์บอร์ดไร้สายบางเฉียบเชื่อมได้ 3 เครื่อง Logitech K380s', 'คีย์บอร์ด Bluetooth น้ำหนักเบา สลับพิมพ์ระหว่างคอม แท็บเล็ต และมือถือในปุ่มเดียว', v_cat_id, 1190, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 24, 5, true, 'Logitech', 'FDE-0233', '8850000000233', 'ตัว', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 24, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'คีย์บอร์ด Bluetooth น้ำหนักเบา สลับพิมพ์ระหว่างคอม แท็บเล็ต และมือถือในปุ่มเดียว', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Logitech', sku = 'FDE-0233', barcode = '8850000000233', unit = 'ตัว', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Chargers & Accessories';
    select product_id into v_pid from public.products where name = 'สาย HDMI 2.1 Ultra High Speed 8K 60Hz ยาว 2 เมตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สาย HDMI 2.1 Ultra High Speed 8K 60Hz ยาว 2 เมตร', 'สายภาพและเสียงความเร็วสูง 48Gbps รองรับ 4K 120Hz และ 8K ถักไนลอนทนทาน', v_cat_id, 299, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'UGREEN', 'FDE-0234', '8850000000234', 'เส้น', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สายภาพและเสียงความเร็วสูง 48Gbps รองรับ 4K 120Hz และ 8K ถักไนลอนทนทาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=600&q=70&auto=format&fit=crop'), brand = 'UGREEN', sku = 'FDE-0234', barcode = '8850000000234', unit = 'เส้น', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Audio & Wearables';
    select product_id into v_pid from public.products where name = 'ไฟวงแหวน LED 10 นิ้วพร้อมขาตั้ง สำหรับประชุมออนไลน์และไลฟ์สด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ไฟวงแหวน LED 10 นิ้วพร้อมขาตั้ง สำหรับประชุมออนไลน์และไลฟ์สด', 'ไฟ Ring Light ปรับอุณหภูมิสีได้ 3 โทน ปรับความสว่าง 10 ระดับ พร้อมที่จับมือถือ', v_cat_id, 490, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Boya', 'FDE-0235', '8850000000235', 'ชุด', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไฟ Ring Light ปรับอุณหภูมิสีได้ 3 โทน ปรับความสว่าง 10 ระดับ พร้อมที่จับมือถือ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&q=70&auto=format&fit=crop'), brand = 'Boya', sku = 'FDE-0235', barcode = '8850000000235', unit = 'ชุด', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'เครื่องดูดฝุ่นมือถือไร้สายสำหรับรถยนต์และโต๊ะทำงาน' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องดูดฝุ่นมือถือไร้สายสำหรับรถยนต์และโต๊ะทำงาน', 'เครื่องดูดฝุ่นมินิแรงดูด 13000Pa กรอง HEPA ล้างน้ำได้ ชาร์จ USB-C', v_cat_id, 990, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 26, 5, true, 'Xiaomi', 'FDE-0236', '8850000000236', 'เครื่อง', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 26, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เครื่องดูดฝุ่นมินิแรงดูด 13000Pa กรอง HEPA ล้างน้ำได้ ชาร์จ USB-C', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'Xiaomi', sku = 'FDE-0236', barcode = '8850000000236', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Tech Corner BKK'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Computer & Smart Home';
    select product_id into v_pid from public.products where name = 'การ์ดความจำ MicroSD 256GB ความเร็วสูงสำหรับกล้องวงจรปิด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'การ์ดความจำ MicroSD 256GB ความเร็วสูงสำหรับกล้องวงจรปิด', 'High Endurance MicroSD ทนบันทึกวนซ้ำ 24 ชม. เหมาะกับกล้องติดรถและกล้องวงจรปิด', v_cat_id, 690, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'SanDisk', 'FDE-0237', '8850000000237', 'ชิ้น', 1, array['warranty_1y', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'High Endurance MicroSD ทนบันทึกวนซ้ำ 24 ชม. เหมาะกับกล้องติดรถและกล้องวงจรปิด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&q=70&auto=format&fit=crop'), brand = 'SanDisk', sku = 'FDE-0237', barcode = '8850000000237', unit = 'ชิ้น', pack_qty = 1, tags = array['warranty_1y', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'เครื่องวัดระยะเลเซอร์ดิจิทัล Bosch GLM 400 ระยะ 40 เมตร' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องวัดระยะเลเซอร์ดิจิทัล Bosch GLM 400 ระยะ 40 เมตร', 'ตลับเมตรเลเซอร์วัดความยาว พื้นที่ และปริมาตรแม่นยำ ±1.5 มม. จอสีอ่านง่าย', v_cat_id, 2490, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 12, 5, true, 'Bosch', 'FDE-0238', '8850000000238', 'เครื่อง', 1, array['warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 12, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ตลับเมตรเลเซอร์วัดความยาว พื้นที่ และปริมาตรแม่นยำ ±1.5 มม. จอสีอ่านง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Bosch', sku = 'FDE-0238', barcode = '8850000000238', unit = 'เครื่อง', pack_qty = 1, tags = array['warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'ชุดดอกสว่านเจาะเหล็ก-ไม้-ปูน Bosch X-Line 33 ชิ้น' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดดอกสว่านเจาะเหล็ก-ไม้-ปูน Bosch X-Line 33 ชิ้น', 'ชุดดอกสว่านและดอกไขควงครบทุกงานในกล่องเดียว ของแท้ทนคม', v_cat_id, 490, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Bosch', 'FDE-0239', '8850000000239', 'ชุด 33 ชิ้น', 33, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ชุดดอกสว่านและดอกไขควงครบทุกงานในกล่องเดียว ของแท้ทนคม', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Bosch', sku = 'FDE-0239', barcode = '8850000000239', unit = 'ชุด 33 ชิ้น', pack_qty = 33, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Power Tools';
    select product_id into v_pid from public.products where name = 'เครื่องเชื่อมไฟฟ้าอินเวอร์เตอร์ขนาดพกพา 140A' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เครื่องเชื่อมไฟฟ้าอินเวอร์เตอร์ขนาดพกพา 140A', 'ตู้เชื่อมมินิน้ำหนักเบา เชื่อมนิ่มไฟนิ่ง พร้อมสายเชื่อมและหน้ากาก', v_cat_id, 2190, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop', 11, 5, true, 'Pumpkin', 'FDE-0240', '8850000000240', 'ชุด', 1, array['tis', 'warranty_1y']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 11, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ตู้เชื่อมมินิน้ำหนักเบา เชื่อมนิ่มไฟนิ่ง พร้อมสายเชื่อมและหน้ากาก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=600&q=70&auto=format&fit=crop'), brand = 'Pumpkin', sku = 'FDE-0240', barcode = '8850000000240', unit = 'ชุด', pack_qty = 1, tags = array['tis', 'warranty_1y']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'คีมตัดสายไฟและปอกสายไฟอเนกประสงค์ 8 นิ้ว Stanley' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คีมตัดสายไฟและปอกสายไฟอเนกประสงค์ 8 นิ้ว Stanley', 'คีมช่างไฟฟ้าด้ามหุ้มฉนวนกันลื่น ตัดคมปอกสายไฟแม่นยำ', v_cat_id, 295, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Stanley', 'FDE-0241', '8850000000241', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'คีมช่างไฟฟ้าด้ามหุ้มฉนวนกันลื่น ตัดคมปอกสายไฟแม่นยำ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'Stanley', sku = 'FDE-0241', barcode = '8850000000241', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Hand Tools';
    select product_id into v_pid from public.products where name = 'สเปรย์พ่นสีอะคริลิคแห้งเร็ว TOA สีดำด้าน/ขาว แพ็ก 2 กระป๋อง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สเปรย์พ่นสีอะคริลิคแห้งเร็ว TOA สีดำด้าน/ขาว แพ็ก 2 กระป๋อง', 'สีสเปรย์เนื้อสีแน่น พ่นเรียบสวยไม่เยิ้ม ใช้ได้ทั้งเหล็ก ไม้ และพลาสติก', v_cat_id, 145, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop', 70, 5, true, 'TOA', 'FDE-0242', '8850000000242', 'แพ็ก 2', 2, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 70, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สีสเปรย์เนื้อสีแน่น พ่นเรียบสวยไม่เยิ้ม ใช้ได้ทั้งเหล็ก ไม้ และพลาสติก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1581147036324-c17ac41dfa6c?w=600&q=70&auto=format&fit=crop'), brand = 'TOA', sku = 'FDE-0242', barcode = '8850000000242', unit = 'แพ็ก 2', pack_qty = 2, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'กุญแจสายยูทองเหลืองแท้ 50 มม. ป้องกันการงัดแงะ Solo' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กุญแจสายยูทองเหลืองแท้ 50 มม. ป้องกันการงัดแงะ Solo', 'แม่กุญแจโซโลแท้ชุบแข็งกันเลื่อย ทนฝนไม่เป็นสนิม พร้อมลูกกุญแจ 3 ดอก', v_cat_id, 289, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Solo', 'FDE-0243', '8850000000243', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แม่กุญแจโซโลแท้ชุบแข็งกันเลื่อย ทนฝนไม่เป็นสนิม พร้อมลูกกุญแจ 3 ดอก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Solo', sku = 'FDE-0243', barcode = '8850000000243', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Electrical & Plumbing';
    select product_id into v_pid from public.products where name = 'ปลั๊กกันน้ำภายนอกอาคาร IP66 มีฝาปิดล็อกได้' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ปลั๊กกันน้ำภายนอกอาคาร IP66 มีฝาปิดล็อกได้', 'เต้ารับคู่กันฝนและฝุ่น เหมาะสำหรับติดตั้งหน้าบ้าน โรงรถ และสวน', v_cat_id, 320, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Hafele', 'FDE-0244', '8850000000244', 'ชุด', 1, array['tis']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เต้ารับคู่กันฝนและฝุ่น เหมาะสำหรับติดตั้งหน้าบ้าน โรงรถ และสวน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1558002038-1055907df827?w=600&q=70&auto=format&fit=crop'), brand = 'Hafele', sku = 'FDE-0244', barcode = '8850000000244', unit = 'ชุด', pack_qty = 1, tags = array['tis']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Chang Pro Hardware'), (select shop_id from public.shops where name = 'Tech Corner BKK'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Car Care';
    select product_id into v_pid from public.products where name = 'น้ำยาล้างแอร์โฟมฉีดคอยล์เย็นไม่ต้องล้างน้ำออก 500 มล. แพ็ก 2' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาล้างแอร์โฟมฉีดคอยล์เย็นไม่ต้องล้างน้ำออก 500 มล. แพ็ก 2', 'โฟมล้างแอร์บ้านและแอร์รถ ขจัดฝุ่นและกลิ่นอับ ลมแอร์เย็นขึ้นและประหยัดไฟ', v_cat_id, 379, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop', 50, 5, true, '3M', 'FDE-0245', '8850000000245', 'แพ็ก 2', 2, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'โฟมล้างแอร์บ้านและแอร์รถ ขจัดฝุ่นและกลิ่นอับ ลมแอร์เย็นขึ้นและประหยัดไฟ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=600&q=70&auto=format&fit=crop'), brand = '3M', sku = 'FDE-0245', barcode = '8850000000245', unit = 'แพ็ก 2', pack_qty = 2, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fitness & Yoga';
    select product_id into v_pid from public.products where name = 'โฟมโรลเลอร์นวดคลายกล้ามเนื้อหลังออกกำลังกาย' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'โฟมโรลเลอร์นวดคลายกล้ามเนื้อหลังออกกำลังกาย', 'Foam Roller ปุ่มนวด 3 มิติ คลายพังผืดและอาการปวดเมื่อยหลังวิ่งหรือนั่งทำงานนาน', v_cat_id, 290, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'FitPro', 'FDE-0246', '8850000000246', 'อัน', 1, array['eco']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'Foam Roller ปุ่มนวด 3 มิติ คลายพังผืดและอาการปวดเมื่อยหลังวิ่งหรือนั่งทำงานนาน', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=600&q=70&auto=format&fit=crop'), brand = 'FitPro', sku = 'FDE-0246', barcode = '8850000000246', unit = 'อัน', pack_qty = 1, tags = array['eco']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Sports';
    select product_id into v_pid from public.products where name = 'ชุดแบดมินตัน 2 ไม้กราไฟท์น้ำหนักเบา พร้อมลูกขนไก่ 3 ลูก' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ชุดแบดมินตัน 2 ไม้กราไฟท์น้ำหนักเบา พร้อมลูกขนไก่ 3 ลูก', 'ไม้แบดมินตันขึ้นเอ็นพร้อมเล่น แข็งแรงน้ำหนักเบา พร้อมกระเป๋าสะพาย', v_cat_id, 690, null, 25, 5, true, 'Yonex Style', 'FDE-0247', '8850000000247', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 25, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ไม้แบดมินตันขึ้นเอ็นพร้อมเล่น แข็งแรงน้ำหนักเบา พร้อมกระเป๋าสะพาย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, null), brand = 'Yonex Style', sku = 'FDE-0247', barcode = '8850000000247', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'ร่มพับกันยูวี 100% โครง 8 ก้านต้านลมแรง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ร่มพับกันยูวี 100% โครง 8 ก้านต้านลมแรง', 'ร่มพับเคลือบสารกันแดด UPF50+ เปิด-ปิดออโต้ในปุ่มเดียว พกติดกระเป๋าสะดวก', v_cat_id, 249, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Urban Fit', 'FDE-0248', '8850000000248', 'คัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ร่มพับเคลือบสารกันแดด UPF50+ เปิด-ปิดออโต้ในปุ่มเดียว พกติดกระเป๋าสะดวก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0248', barcode = '8850000000248', unit = 'คัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Bags & Accessories';
    select product_id into v_pid from public.products where name = 'แว่นตากันแดดเลนส์โพลาไรซ์ตัดแสงสะท้อน UV400' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แว่นตากันแดดเลนส์โพลาไรซ์ตัดแสงสะท้อน UV400', 'แว่นกันแดดใส่ขับรถสบายตา ลดแสงจ้าจากถนนและแดด น้ำหนักเบาไม่บีบขมับ', v_cat_id, 390, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop', 45, 5, true, 'Urban Fit', 'FDE-0249', '8850000000249', 'อัน', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 45, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แว่นกันแดดใส่ขับรถสบายตา ลดแสงจ้าจากถนนและแดด น้ำหนักเบาไม่บีบขมับ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1597484661643-2f5fef640dd1?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0249', barcode = '8850000000249', unit = 'อัน', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'เบาะรองนั่งเจลรังผึ้งลดอาการปวดหลังออฟฟิศซินโดรม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'เบาะรองนั่งเจลรังผึ้งลดอาการปวดหลังออฟฟิศซินโดรม', 'เบาะเจลระบายความร้อน นั่งทำงานนานไม่ปวดก้นกบ พร้อมปลอกกันลื่นถอดซักได้', v_cat_id, 299, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 55, 5, true, 'Urban Fit', 'FDE-0250', '8850000000250', 'ชิ้น', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 55, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'เบาะเจลระบายความร้อน นั่งทำงานนานไม่ปวดก้นกบ พร้อมปลอกกันลื่นถอดซักได้', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Urban Fit', sku = 'FDE-0250', barcode = '8850000000250', unit = 'ชิ้น', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Urban Fit & Style'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Baby Gear';
    select product_id into v_pid from public.products where name = 'น้ำยาล้างขวดนมออร์แกนิก D-nee 600 มล. แพ็ก 3 ถุง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำยาล้างขวดนมออร์แกนิก D-nee 600 มล. แพ็ก 3 ถุง', 'น้ำยาล้างขวดนมฟู้ดเกรด ขจัดคราบไขมันนมสะอาดหมดจด ไร้สารตกค้าง', v_cat_id, 179, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'D-nee', 'FDE-0251', '8850000000251', 'แพ็ก 3', 3, array['organic', 'eco', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'น้ำยาล้างขวดนมฟู้ดเกรด ขจัดคราบไขมันนมสะอาดหมดจด ไร้สารตกค้าง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&q=70&auto=format&fit=crop'), brand = 'D-nee', sku = 'FDE-0251', barcode = '8850000000251', unit = 'แพ็ก 3', pack_qty = 3, tags = array['organic', 'eco', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Cat Food & Litter';
    select product_id into v_pid from public.products where name = 'อาหารแมวลูกแมว Royal Canin Kitten 2 กก.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารแมวลูกแมว Royal Canin Kitten 2 กก.', 'อาหารสูตรลูกแมว 4-12 เดือน เสริมภูมิคุ้มกันและโปรตีนย่อยง่าย', v_cat_id, 820, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop', 35, 5, true, 'Royal Canin', 'FDE-0252', '8850000000252', 'ถุง 2 กก.', 1, array['pet_safe', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 35, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารสูตรลูกแมว 4-12 เดือน เสริมภูมิคุ้มกันและโปรตีนย่อยง่าย', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=70&auto=format&fit=crop'), brand = 'Royal Canin', sku = 'FDE-0252', barcode = '8850000000252', unit = 'ถุง 2 กก.', pack_qty = 1, tags = array['pet_safe', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Dog Food & Treats';
    select product_id into v_pid from public.products where name = 'อาหารเปียกสุนัข Cesar รสเนื้อไก่และผัก แพ็ก 6 ถาด' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'อาหารเปียกสุนัข Cesar รสเนื้อไก่และผัก แพ็ก 6 ถาด', 'อาหารเปียกเกรดพรีเมียมเนื้อนุ่มหอมอร่อย สุนัขทานยากชอบมาก', v_cat_id, 264, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Cesar', 'FDE-0253', '8850000000253', 'แพ็ก 6 ถาด', 6, array['pet_safe', 'wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'อาหารเปียกเกรดพรีเมียมเนื้อนุ่มหอมอร่อย สุนัขทานยากชอบมาก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=70&auto=format&fit=crop'), brand = 'Cesar', sku = 'FDE-0253', barcode = '8850000000253', unit = 'แพ็ก 6 ถาด', pack_qty = 6, tags = array['pet_safe', 'wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'กระบะทรายแมวทรงโดมป้องกันทรายกระเด็นพร้อมที่ตัก' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระบะทรายแมวทรงโดมป้องกันทรายกระเด็นพร้อมที่ตัก', 'ห้องน้ำแมวมีฝาปิดช่วยเก็บกลิ่น ถอดล้างง่าย พื้นที่กว้างขวาง', v_cat_id, 450, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 30, 5, true, 'Paw & Glow', 'FDE-0254', '8850000000254', 'ชุด', 1, array['pet_safe']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 30, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ห้องน้ำแมวมีฝาปิดช่วยเก็บกลิ่น ถอดล้างง่าย พื้นที่กว้างขวาง', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0254', barcode = '8850000000254', unit = 'ชุด', pack_qty = 1, tags = array['pet_safe']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Pet Accessories';
    select product_id into v_pid from public.products where name = 'หวีแปรงขนแมวและสุนัขแบบกดดันขนออกอัตโนมัติ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'หวีแปรงขนแมวและสุนัขแบบกดดันขนออกอัตโนมัติ', 'แปรงสางขนร่วงปลายตุ่มนุ่มไม่บาดผิว กดปุ่มเดียวขนหลุดออกเป็นแผ่น', v_cat_id, 169, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop', 65, 5, true, 'Paw & Glow', 'FDE-0255', '8850000000255', 'อัน', 1, array['pet_safe', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 65, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'แปรงสางขนร่วงปลายตุ่มนุ่มไม่บาดผิว กดปุ่มเดียวขนหลุดออกเป็นแผ่น', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0255', barcode = '8850000000255', unit = 'อัน', pack_qty = 1, tags = array['pet_safe', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Skincare';
    select product_id into v_pid from public.products where name = 'ลิปบาล์มบำรุงริมฝีปากชุ่มชื้นไม่มีสี Nivea แพ็ก 2 แท่ง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ลิปบาล์มบำรุงริมฝีปากชุ่มชื้นไม่มีสี Nivea แพ็ก 2 แท่ง', 'ลิปมันบำรุงปากแตกแห้งด้วยเชียบัตเตอร์และออยล์ธรรมชาติ', v_cat_id, 158, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop', 75, 5, true, 'Nivea', 'FDE-0256', '8850000000256', 'แพ็ก 2', 2, array['fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 75, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ลิปมันบำรุงปากแตกแห้งด้วยเชียบัตเตอร์และออยล์ธรรมชาติ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=70&auto=format&fit=crop'), brand = 'Nivea', sku = 'FDE-0256', barcode = '8850000000256', unit = 'แพ็ก 2', pack_qty = 2, tags = array['fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Fragrance & Aroma';
    select product_id into v_pid from public.products where name = 'น้ำหอมฉีดผ้าและตัวกลิ่นแป้งเด็กหอมละมุน 100 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'น้ำหอมฉีดผ้าและตัวกลิ่นแป้งเด็กหอมละมุน 100 มล.', 'Body & Fabric Mist กลิ่นสะอาดสดชื่น ไม่ฉุน ใช้ได้ทั้งผิวและเสื้อผ้า', v_cat_id, 249, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Paw & Glow', 'FDE-0257', '8850000000257', 'ขวด', 1, array['fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'Body & Fabric Mist กลิ่นสะอาดสดชื่น ไม่ฉุน ใช้ได้ทั้งผิวและเสื้อผ้า', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6?w=600&q=70&auto=format&fit=crop'), brand = 'Paw & Glow', sku = 'FDE-0257', barcode = '8850000000257', unit = 'ขวด', pack_qty = 1, tags = array['fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Vitamins & Supplements';
    select product_id into v_pid from public.products where name = 'คอลลาเจนเปปไทด์บริสุทธิ์ 100% ญี่ปุ่น 200 กรัม' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'คอลลาเจนเปปไทด์บริสุทธิ์ 100% ญี่ปุ่น 200 กรัม', 'คอลลาเจนละลายน้ำง่ายไม่คาว 0% ไขมันและน้ำตาล บำรุงผิว ผม และข้อต่อ', v_cat_id, 590, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Meiji Style', 'FDE-0258', '8850000000258', 'กระป๋อง', 1, array['low_sugar', 'fda', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'คอลลาเจนละลายน้ำง่ายไม่คาว 0% ไขมันและน้ำตาล บำรุงผิว ผม และข้อต่อ', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop'), brand = 'Meiji Style', sku = 'FDE-0258', barcode = '8850000000258', unit = 'กระป๋อง', pack_qty = 1, tags = array['low_sugar', 'fda', 'bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Vitamins & Supplements';
    select product_id into v_pid from public.products where name = 'โพรไบโอติก 10 สายพันธุ์บำรุงลำไส้ กล่อง 30 ซอง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'โพรไบโอติก 10 สายพันธุ์บำรุงลำไส้ กล่อง 30 ซอง', 'จุลินทรีย์ดีช่วยปรับสมดุลระบบขับถ่าย ลดท้องอืด ทานง่ายรสโยเกิร์ต', v_cat_id, 650, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop', 38, 5, true, 'BioBalance', 'FDE-0259', '8850000000259', 'กล่อง 30 ซอง', 30, array['halal', 'low_sugar', 'fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 38, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'จุลินทรีย์ดีช่วยปรับสมดุลระบบขับถ่าย ลดท้องอืด ทานง่ายรสโยเกิร์ต', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=70&auto=format&fit=crop'), brand = 'BioBalance', sku = 'FDE-0259', barcode = '8850000000259', unit = 'กล่อง 30 ซอง', pack_qty = 30, tags = array['halal', 'low_sugar', 'fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'First Aid & Care';
    select product_id into v_pid from public.products where name = 'สเปรย์พ่นจมูกน้ำเกลือบริสุทธิ์สำหรับภูมิแพ้ 100 มล.' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'สเปรย์พ่นจมูกน้ำเกลือบริสุทธิ์สำหรับภูมิแพ้ 100 มล.', 'สเปรย์น้ำทะเลธรรมชาติช่วยล้างฝุ่น PM2.5 และลดอาการคัดจมูก ใช้ได้ทั้งเด็กและผู้ใหญ่', v_cat_id, 285, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop', 50, 5, true, 'Marimer', 'FDE-0260', '8850000000260', 'ขวด', 1, array['fda']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 50, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สเปรย์น้ำทะเลธรรมชาติช่วยล้างฝุ่น PM2.5 และลดอาการคัดจมูก ใช้ได้ทั้งเด็กและผู้ใหญ่', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600&q=70&auto=format&fit=crop'), brand = 'Marimer', sku = 'FDE-0260', barcode = '8850000000260', unit = 'ขวด', pack_qty = 1, tags = array['fda']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'กระดานไวท์บอร์ดแม่เหล็กตั้งโต๊ะ A3 พร้อมปากกาและแปรงลบ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'กระดานไวท์บอร์ดแม่เหล็กตั้งโต๊ะ A3 พร้อมปากกาและแปรงลบ', 'กระดานวางแผนงานรายวันบนโต๊ะทำงาน เขียนลื่นลบสะอาด', v_cat_id, 290, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 40, 5, true, 'Elephant', 'FDE-0261', '8850000000261', 'ชุด', 1, array['bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 40, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'กระดานวางแผนงานรายวันบนโต๊ะทำงาน เขียนลื่นลบสะอาด', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Elephant', sku = 'FDE-0261', barcode = '8850000000261', unit = 'ชุด', pack_qty = 1, tags = array['bestseller']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Desk Organization';
    select product_id into v_pid from public.products where name = 'แฟ้มซองซิปกันน้ำใส่เอกสาร A4 แพ็ก 10 ใบ' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'แฟ้มซองซิปกันน้ำใส่เอกสาร A4 แพ็ก 10 ใบ', 'ซองซิปตาข่ายหนา กันน้ำ แยกเก็บเอกสาร บิล และอุปกรณ์เครื่องเขียนได้สะดวก', v_cat_id, 149, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop', 80, 5, true, 'Elephant', 'FDE-0262', '8850000000262', 'แพ็ก 10 ใบ', 10, array['wholesale']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 80, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'ซองซิปตาข่ายหนา กันน้ำ แยกเก็บเอกสาร บิล และอุปกรณ์เครื่องเขียนได้สะดวก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=600&q=70&auto=format&fit=crop'), brand = 'Elephant', sku = 'FDE-0262', barcode = '8850000000262', unit = 'แพ็ก 10 ใบ', pack_qty = 10, tags = array['wholesale']::text[] where product_id = v_pid;
    end if;
    select coalesce((select shop_id from public.shops where name = 'Paw & Glow Studio'), (select shop_id from public.shops where name = 'Somsri Home & Living'), (select min(shop_id) from public.shops)) into v_shop_id;
    select category_id into v_cat_id from public.categories where name = 'Printer & Supplies';
    select product_id into v_pid from public.products where name = 'ฉลากสติกเกอร์ความร้อนสำหรับพิมพ์ใบปะหน้า 100x150 มม. 500 ดวง' limit 1;
    if v_pid is null then
        insert into public.products (shop_id, name, description, category_id, price, image_url, stock_qty, low_stock_threshold, is_active, brand, sku, barcode, unit, pack_qty, tags) values (v_shop_id, 'ฉลากสติกเกอร์ความร้อนสำหรับพิมพ์ใบปะหน้า 100x150 มม. 500 ดวง', 'สติกเกอร์บาร์โค้ดกันน้ำกันน้ำมัน กาวเหนียวติดแน่น พิมพ์คมชัดไม่ต้องใช้หมึก', v_cat_id, 119, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop', 110, 5, true, 'ThermalPro', 'FDE-0263', '8850000000263', 'ม้วน 500 ดวง', 500, array['wholesale', 'bestseller']::text[]) returning product_id into v_pid;
        insert into public.stock_movements (product_id, qty_change, reason, note) values (v_pid, 110, 'INITIAL', 'Catalog seed');
    else
        update public.products set description = 'สติกเกอร์บาร์โค้ดกันน้ำกันน้ำมัน กาวเหนียวติดแน่น พิมพ์คมชัดไม่ต้องใช้หมึก', category_id = coalesce(v_cat_id, category_id), image_url = coalesce(image_url, 'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=600&q=70&auto=format&fit=crop'), brand = 'ThermalPro', sku = 'FDE-0263', barcode = '8850000000263', unit = 'ม้วน 500 ดวง', pack_qty = 500, tags = array['wholesale', 'bestseller']::text[] where product_id = v_pid;
    end if;
end $$;

-- 4. Add shop coupons if missing
insert into public.coupons (code, shop_id, discount_type, discount_value, max_discount, min_order_amount, usage_limit_total, usage_limit_per_user, starts_at, expires_at) select 'TECH100', s.shop_id, 'FIXED', 100, null, 1000, 200, 2, now(), now() + interval '90 days' from public.shops s where s.name = 'Tech Corner BKK' on conflict (code) do nothing;
insert into public.coupons (code, shop_id, discount_type, discount_value, max_discount, min_order_amount, usage_limit_total, usage_limit_per_user, starts_at, expires_at) select 'PANTRY15', s.shop_id, 'PERCENT', 15, 120, 400, 300, 3, now(), now() + interval '90 days' from public.shops s where s.name = 'Somsri Home & Living' on conflict (code) do nothing;
insert into public.coupons (code, shop_id, discount_type, discount_value, max_discount, min_order_amount, usage_limit_total, usage_limit_per_user, starts_at, expires_at) select 'CHANG150', s.shop_id, 'FIXED', 150, null, 1500, 150, 2, now(), now() + interval '90 days' from public.shops s where s.name = 'Tech Corner BKK' on conflict (code) do nothing;

commit;
